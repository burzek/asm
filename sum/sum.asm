                    section .text
                    global _start
                    
;----------------   MAIN -------------                    
_start:	
                    pop rsi                 ;read argument count from top of stack
                    cmp rsi, 2
                    jne printerr
		
                    add rsp, 8              ;skip args[0]
                    pop rsi                 ;read args[1]
                    call str2num            ;convert it to number

                    mov rcx, rax            ;sum all numbers from 1..args[1]
                    xor rax, rax
sumloop:            add rax, rcx
                    loop sumloop
                    
                    call num2str
                    call printresult

exit:               mov rax, 60             ;exit program
                    mov rdi, 0
                    syscall

;----------------  MAIN END -------------


;convert string to number
;input:     rsi - pointer to string
;output:    rax - result
str2num:            mov rcx, 10
                    xor rax, rax
                    xor rbx, rbx
s2nloop:	         cmp byte [rsi], 0
                    je s2ndone
                    mov bl, byte [rsi]
                    sub bl, '0'
                    mul rcx
                    add rax, rbx	
                    inc rsi
                    jmp s2nloop
s2ndone:            ret


;num2str
;input:     rax - number to convert
;return:    rax - length of string
;           rsi - pointer to string representation
num2str:            mov rbx, 10
                    mov r8, 0
n2sloop:            xor rdx, rdx
                    div rbx
                    add rdx, '0'
                    push dx
                    inc r8
                    cmp rax, 0
                    jne n2sloop	
                    mov rsi, bNumPrintArr
                    mov rcx, r8
rev:                pop dx
                    mov byte [rsi], dl
                    inc rsi
                    loop rev
                    mov rsi, bNumPrintArr
                    mov rax, r8
                    ret
		

;print text
;input:     rsi - pointer to string
;           rax - length of string
println:            mov rcx, rsi
                    add rcx, rax
                    mov byte [rcx], 10
                    inc rax
print:              mov rdx, rax
                    mov rax, 1
                    mov rdi, 1
                    syscall
                    ret

;show result message
printresult:        push rax
                    push rsi
                    mov rsi, resmsg
                    mov rax, resmsgl
                    call print
                    pop rsi
                    pop rax
                    call println
                    ret

;show error message
printerr:           mov rsi, argmsg
                    mov rax, argmsgl
                    call println
                    jmp exit


                    section .bss
bNumPrintArr        resb 16

                    section .data
resmsg              db "Sum of numbers is:"                    
resmsgl             equ $ - resmsg
argmsg              db "One numeric argument required"
argmsgl             equ $ - argmsg	