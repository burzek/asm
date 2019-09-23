all: 		compile linker

compile: 	
			nasm -f elf64 hello.asm

linker:   	
			ld -s -o hello hello.o

clean :
			rm *.o
