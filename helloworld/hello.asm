        section .text
	global _main

_main:  mov rax, 1      ;write sys call
        mov rdi, 1      ;std out
        mov rsi, msg
        mov rdx, len
        syscall

        mov rax,60      ;exit sys call
        mov rdi,0
        syscall

        section .data
msg:    db "Hello, world",10
len:    equ $ - msg

