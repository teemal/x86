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

section	.bss
	size:	equ	1024	;const 1024 bits for buffer
	buffer:	resb	size	;

section	.data
	user_message	db	'please enter balanced brackets, YA DINGUS!', 0x0a
			;asks user for input
	len_message	equ	$-user_message
			;length of user_message
	user_error	db	'ERROR! Enter balanced brackets, ya dummy!'
			;error message
	error_len	equ	$-user_error
			;length of error message

section	.text
	global _start
_start:
	write_string	user_message,len_message

	read_string	buffer,size

	reset_registers

	mov	cx,'['	;TEST
	push	cx	;TEST
	pop	dx	;TEST

	mov	eax,1
	mov	ebx,0
	int	80h
