all: encoder decoder


encoder.o: encoder.asm
	nasm -f elf -g -F stabs encoder.asm
encoder: encoder.o
	ld  -o encoder encoder.o
decoder.o: decoder.asm
	nasm -f elf -g -F stabs decoder.asm
decoder: decoder.o
	ld  -o decoder decoder.o

clean:
	rm *.o
