#_*_Makefile_*_

mallory_hw5: mallory_hw5.o
	ld  -o mallory_hw5 mallory_hw5.o

mallory_hw5.o: mallory_hw5.asm
	nasm -f elf -g -F stabs mallory_hw5.asm
clean:
	rm *.o
