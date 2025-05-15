# CMSC313HW11
Produce a program that will take a number of bytes of data and print that data to the screen.   
AUTHORING: 
    Thomas Benzing, UMBC, 5/15/2025, 2:10PM
PURPOSE OF SOFTWARE:  
    take a number of bytes of data and print that data to the screen
FILES: 
    translatetoascii.asm, main source code
    README.md, instructions and details
BUILD INSTRUCTIONS: 
    use on a linux machine
    To assemble, link, and run:
        nasm -f elf32 translatetoascii.asm -o translatetoascii.o
        ld -m elf_i386 translatetoascii.o -o translatetoascii
        ./translatetoascii