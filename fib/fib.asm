                section .text
                global _start
                
; ---------------- MAIN ---------------
_start: 
                ;read parameters
                pop rsi
                cmp rsi, 2
                je paramok
                jmp printerr

paramok:        pop rsi
                pop rsi
                call str2num
                
                mov rcx, 1
next:           mov rbx, qword [fib2]
                mov rdx, qword [fib1]
                mov qword [fib2], rdx
                add qword [fib1], rbx
                inc rcx
                cmp rcx, rax
                jne next
                mov rax, qword [fib1]       ;fib(n)
                
                call num2str
                call print
                
                jmp exit       
                
                                

; ------------ END MAIN -----------------

                
exit:           mov rax, 60
                mov rdi, 0
                syscall   
                
printerr:       mov rax, 1
                mov rdi, 1
                mov rsi, argerrmsg
                mov rdx, argerrmsgl
                syscall
                jmp exit
                
;convert string to number
;@input:     rsi - pointer to string
;@output:    rax - result                
str2num:        xor rax, rax
str2num_i:      mov rcx, 10
                cmp byte [rsi], 0
                je str2num_done
                movzx rbx, byte [rsi]
                sub bl, '0'
                mul rcx
                add rax, rbx
                inc rsi
                jmp str2num_i
str2num_done:   ret                   
                
        
;convert number to string
;@input:        rax - number to convert
;@output:       rsi - pointer to string
;               rdx - string length                                                                
num2str:        mov rbx, 10
                mov rcx, 0
num2str_i:      xor rdx, rdx
                div rbx
                add rdx, '0'
                push dx  
                inc rcx
                cmp rax, 0
                jne num2str_i
                mov r8, rcx
                mov rsi, num2str_arr            
rev:            pop dx
                mov byte [rsi], dl
                inc rsi
                loop rev
                mov rsi, num2str_arr
                mov rdx, r8
                                                  
                ret                
                
                                                                                                    
print:          mov rax, 1
                mov rdi, 1
                syscall
                ret                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                
                section .data
argerrmsg       db "One numeric parameter required", 10
argerrmsgl      equ $ - argerrmsg
fib2            dq 0
fib1            dq 1

                section .bss
num2str_arr     resb 16                