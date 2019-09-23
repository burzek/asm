all:compile linker

compile:
	nasm -f elf64 sum.asm -l sum.lst -gdwarf

linker:
	ld -g -o sum sum.o

clean:
	rm *.o *.lst sum
