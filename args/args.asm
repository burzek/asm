		section .text
		global _start
_start:	

		pop rcx
		cmp rcx, 3
		jne arg_err
		jmp end


arg_err:	mov rax, WRITE
		mov rdi, STDOUT
		mov rsi, argerrmsg
		mov rdx, argerrmsg_l
		syscall

print:		push rax
		push rdi
		push rsi

end:		mov rax, 60
		mov rdi, 0
		syscall		

	
		section .data
argerrmsg:	db "Expected 2 numeric arguments", 10
argerrmsg_l:	equ $ - argerrmsg	

WRITE:		equ 1
STDOUT:		equ 1		
