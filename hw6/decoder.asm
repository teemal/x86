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
	%endmacro
	
section .bss
        size:          equ	1024	;const 1024 bits for buffer
	buffer:        resb	size	;
	buff_len:      equ     $-buffer	;
	new_size:      equ     1024            ;new buff size
	new_buffer:    resb    size            ;
	new_buff_len:  equ     $-new_buffer
	
section .data
        user_message	db	'GIMME AN ENCODED STRING AND ILL DECODE IT, YO!', 0x0a
			;asks user for input
	len_message	equ	$-user_message
			;length of user_message
        test_msg        db      ' '
        test_len        equ     $-test_msg
        
section .text
        global _start
_start:
        mov                     esi,esp         ;empty stack location
        write_string            user_message,len_message
        read_string             buffer,buff_len
        add                     ecx,eax         ;go to EOL char
        dec                     ecx
        dec                     ecx
        mov                     edi,eax         ;buff_length
push_to_buff:
        reset_registers
        mov                     al,[ecx]
        push                    ax
        reset_registers
        dec                     ecx
        dec                     edi
        cmp                     edi,1
        je                      pop_from_stack
        jmp                     push_to_buff
pop_from_stack:
        reset_registers
        mov                     ecx,0
        mov                     edx,0
        pop                     ax
        pop                     bx
        sub                     bl,48                   ;true dec value
put_it_in_my_buff:
        mov                     [new_buffer],ax
        cmp                     ebx,1
        je                      last_dec
        dec                     bl
        jmp                     put_it_in_my_buff
last_dec:
        reset_registers
        cmp                     esp,esi
        je                      output
        jmp                     pop_from_stack
output:
        write_string            new_buffer,new_buff_len
        mov                     eax,1
        mov                     ebx,0
        int                     80h