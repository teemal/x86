section	.bss
	size:	equ	1024	;const 1024 byte for buffer
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
	mov	eax,4	;user prompt
	mov	ebx,1
	mov	ecx,user_message
	mov	edx,len_message
	int	80h	;linux kernel call (interrupt)

	mov	eax,3   ;user input
        mov	ebx,0
        mov	ecx,buffer
        mov	edx,1
        int	80h     ;linux kernel call (interrupt)

	mov	eax,0	;reset registers
	mov	ebx,0
	mov	ecx,0
	mov	edx,0

	push	buffer	;push the buffer onto the stack (little endian)
	pop	dx	;pop top value into dx

	cmp	dx,'{'	;begin comparisons
	je	eq_open
	cmp	dx,'('
	je	eq_open
	cmp	dx,'['
	je	eq_open
	cmp	dx,'}'
	je	eq_closed
	cmp	dx,')'
	je	eq_closed
	cmp	dx,']'
	je	eq_closed	;final comparison

;NEED TO SEE IF STACK IS EMPTY FOR CONTROL FLOW
;IF NOT EMPTY THEN COMPARE IF EMPTY CHECK EAX AND STDOUT

	mov	eax,1	;sys exit call
	mov	ebx,0	;return 0
	int	80h	;kernel call

eq_open:
	inc	eax	;increment eax by 1
eq_closed:
	dec	eax	;decrement eax by 1

zero:			;messages user that brackets are balanced
	mov	eax,4	;user message
	mov	ebx,1
	mov	ecx,user_message
	mov	edx,len_message
	int	80h	;linux kernel call

not_zero:		;error message (unbalanced brackets)
	mov	eax,4	;user prompt
	mov	ebx,1
	mov	ecx,user_error
	mov	edx,error_len
	int	80h	;kernel call
