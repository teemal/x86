#_*_Makefile_*_

mallory_hw4: mallory_hw4.o
	ld -o mallory_hw4 mallory_hw4.o

mallory_hw4.o: mallory_hw4.asm
	nasm -f elf -g -F stabs mallory_hw4.asm

clean:
	rm *.o
