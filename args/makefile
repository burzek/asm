all: 		compile linker

compile:
	nasm -f elf64 args.asm -l args.lst -gdwarf

linker:
	ld -g -o args args.o

clean:
	rm *.o args
