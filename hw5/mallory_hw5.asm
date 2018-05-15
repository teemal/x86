;macro for system write
	%macro	write_string	2
	mov	eax,4	;sys write
	mov	ebx,1	;stdout
	mov	ecx,%1	;message param
	mov	edx,%2	;message len param
	int	80h	;kernel call (interupt)
	%endmacro

;macro for system read
	%macro	read_string	2
	mov	eax,3	;sys read
	mov	ebx,0	;stdin
	mov	ecx,%1	;buffer param
	mov	edx,%2	;buffer size param
	int	80h
	%endmacro

;macro to reset registers
	%macro reset_registers	0
	mov	eax,0
	mov	ebx,0
	mov	ecx,0
	mov	edx,0
	%endmacro

;macro to push and pop buffer to and from stack
	%macro	pull_char	2
	mov	ecx,%1		;move buffer into ecx
	mov	dl,[ecx]	;put last char into dl
	%endmacro

section	.bss
	size:	equ	1024	;const 1024 bits for buffer
	buffer:	resb	size	;
	buff_len: equ $-buffer	;

section	.data
	user_message	db	'please enter balanced brackets, YA DINGUS!', 0x0a
			;asks user for input
	len_message	equ	$-user_message
			;length of user_message
	user_error	db	'ERROR! Enter balanced brackets, ya dummy!',0x0a
			;error message
	error_len	equ	$-user_error
			;length of error message
	test_mssg	db	'TEST-got to end of string'
	test_len	equ	$-test_mssg

section	.text
	global _start
_start:
	mov	edi,esp		;moves stack pointer to edi so as to not hardcode the empty stack address
	write_string	user_message,len_message

	read_string	buffer,size
	reset_registers

	pull_char	buffer,buff_len

	jmp	compare

	mov	eax,1
	mov	ebx,0
	int	80h
compare:	;compares single buffer value to list and goes from there
	cmp	dl,0xa
	je	last_check
	cmp	dl,'['
	je	pusher
	cmp	dl,'{'
	je	pusher
	cmp	dl,'('
	je	pusher
	cmp	dl,']'
	je	closed_brack
	cmp	dl,'}'
	je	closed_brack
	cmp	dl,')'
	je	closed_brack
	inc	ecx		;if no EOL or bracket, increment and repeat
	mov	dl,0
	mov	dl,[ecx]
	jmp	compare
closed_brack:
	cmp	esp,0xbffff040
	je	fail_mssg
	cmp	dl,']'
	je	popper_square
	cmp	dl,'}'
	je	popper_curly
	cmp	dl,')'
	je	popper_paren
fail_mssg:
	write_string	user_error,error_len
	mov	eax,1
	mov	ebx,0
	int	80h
pusher:
	mov	bl,dl
	push	edx
	inc	ecx
	mov	dl,0
	mov	dl,[ecx]
	jmp	compare
popper_square:
	pop	eax
	cmp	eax,'['
	jne	fail_mssg
	inc	ecx
	mov	dl,0
	mov	dl,[ecx]
	jmp	compare
popper_curly:
	pop	eax
	cmp	eax,'{'
	jne	fail_mssg
	inc	ecx
	mov	dl,0
	mov	dl,[ecx]
	jmp	compare
popper_paren:
	pop	eax
	cmp	eax,'('
	jne	fail_mssg
	inc	ecx
	mov	dl,0
	mov	dl,[ecx]
	jmp	compare
last_check:
	cmp	esp,edi
	jne	fail_mssg
	jmp	success_mssg
success_mssg:
	write_string	buffer,buff_len
	mov	eax,1	;exit
	mov	ebx,0
	int	80h
