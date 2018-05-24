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
	mov     ecx,0
	%endmacro
	
;macro for sys exit
    %macro system_exit  0
    mov eax,1
    mov ebx,0
    int 80h
	%endmacro
section .bss
	size:          equ	1024	;const 1024 bits for buffer
	buffer:        resb	size	;
	buff_len:      equ     $-buffer	;
	new_size:      equ     1024            ;new buff size
	new_buffer:    resb    size            ;
	new_buff_len:  equ     $-new_buffer
section .data
    user_message	db	'GIMME SOME ASCII CHARACTERS AND ILL ENCODE IT, YO!', 0x0a
			;asks user for input
	len_message	equ	$-user_message
			;length of user_message
        test_msg        db      ' ', 0x0a
        test_len        equ     $-test_msg
section .text
    global _start
_start:
        mov     esi,esp         ;stack pointer into edi to know when stack is empty
        write_string    user_message,len_message
        read_string     buffer,buff_len
        add     ecx,eax         ;go to EOL char
        dec     ecx
        dec     ecx
        mov     edx,0           
        mov     dl,[ecx]        ;last char in string
push_to_stack:
        push    dx              
        dec     ecx
        dec     eax
        mov     edx,0
        mov     dl,[ecx]
        cmp     eax,1           ;1 = EOL minus new line char
        je      set_counter
        jmp    push_to_stack
set_counter:
        reset_registers
        mov     edx,0
        mov     dl,1
chiggity_check_yo_self:
        pop     ax
        cmp     esp,esi
        je      last_char
        pop     bx
        cmp     ax,bx
        jne     new_char
        inc     edx
        push    ax
        reset_registers
        jmp     chiggity_check_yo_self
        
new_char:
        push bx
        mov     edi,edx
        ;ADD BX TO NEW BUFFER THEN ADD ECX TO NEW BUFFER
        mov     [new_buffer],al
        write_string    new_buffer,new_buff_len
        add     edi,48
        mov     [new_buffer],edi
        ;==============================================
        write_string    new_buffer,new_buff_len
        jmp     set_counter
last_char:
        mov     edi,edx
        mov     [new_buffer],al
        write_string    new_buffer,new_buff_len
        add     edi,48
        mov     [new_buffer],edi
        write_string    new_buffer,new_buff_len
        write_string    test_msg,test_len
        mov     eax,1
        mov     ebx,0
        int     80h