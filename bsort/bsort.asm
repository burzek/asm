;todo
; funckie uppercase?
; funckie: push/pop aby nemenili registre
; debug parse, printarr
; bsort
; macro/kniznica

                                        
                    section .text
                    global _start

; ---------------- MAIN ---------------
_start:             call loadFile
                    call parse
                    call printArray
                    call bsort
                    call printArray
                    
                    jmp exit

;parse text data file (format num,num,num.....\n)
;input:  rsi - adress of text data
;output: rax - number of elements       
;        rsi - address of qword array
parse:              mov rax, 0          ;converted number
                    mov rcx, 10         ;multiplier
                    mov rdx, 0          ;number of elements
.next:              movzx rbx, byte [rsi]
                    cmp rbx, '\n'
                    je .parsedone
                    cmp rbx, ','
                    je .numdone
                    sub rbx, '0'
                    mul rcx
                    add rax, rbx
                    inc rsi
                    jmp .next    
.numdone:           mov qword [data], rax
                    add rdi, 8        
                    inc rdx           
.parsedone:         mov rsi, data
                    mov rax, rdx          
                    ret

bsort:              
                    ret

;print array of dword numbers
;input:  rsi - qword array address 
;        rax - number of elements
;output: none
printArray:         mov rcx, rax
                    mov rbx, 0
.next               mov rax, qword [rsi + rbx]
                    add rbx, 8
                    call itostr
                    call print
                    loop .next
                    ret   
                    
;convert qword number to string
;input:  rax - number to convert
;output: rsi - address of \0 terminated string                    
itostr:             mov rbx, 10
                    mov rcx, 0
.next:              xor rdx, rdx
                    div rbx
                    add rdx, '0'
                    push dx  
                    inc rcx
                    cmp rax, 0
                    jne .next
                    mov dx, 0       ;add 0 to end of string
                    push dx
                    inc rcx
                    mov rsi, i2strarr            
.rev:               pop dx
                    mov byte [rsi], dl
                    inc rsi
                    loop .rev
                    mov rsi, i2strarr
                    ret                                                                                                 

;load file content
;input:  rsi - address of file name
;output: rsi - address of data
loadFile:           mov rax, 2
                    mov rdi, fileName
                    mov rsi, O_RDONLY
                    mov rdx, FILE_MODE
                    syscall
                    cmp rax, 0      ;check exit value
                    jl notfound
                    mov rdi, rax    ;read data
                    
                    mov rsi, buffer
                    mov rdx, BUFFER_SIZE   ;buffer size
.next:              mov rax, 0      
                    syscall
                    add rsi, rax
                    cmp rax, BUFFER_SIZE
                    je .next
                    ret
                    
;print error (input file not found) and exit
;input:  none
;output: none                      
notfound:           mov rsi, fileNotFound
                    call print
                    jmp exit                    
    
;print text
;input:  rsi - address of \0 terminated text   
;output: none 
print:              mov rax, 1
                    mov rdi, 1
                    ;find size
                    mov rdx, 0
.next:              cmp byte [rsi + rdx], 0
                    je .found 
                    inc rdx
                    jmp .next
.found:             syscall
                    jmp exit
                    
;putc
;input:  rax - char to print
putc:               mov byte [.ch], al
                    mov rax, 1
                    mov rdi, 1
                    mov rdx, 1
.ch:                nop             ;;                    
                                         

;exit application
;input:  none
;output: none
exit:               mov rax, 60
                    mov rdi, 0
                    syscall
                    

                    section .bss
data:               resq 100                                        
i2strarr:           resb 16  
                    section .data
fileName:           db "/home/boris/Work/Workspaces/asm/bsort/input.txt",0
fileNotFound:       db "File not found", 0

O_RDONLY:           equ 0
FILE_MODE:          equ 00600o 

BUFFER_SIZE:        equ 1024
buffer:             equ $
              