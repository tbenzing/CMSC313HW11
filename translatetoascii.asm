
section .data
inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
inputLen equ $ - inputBuf

hexDigits db "0123456789ABCDEF", 0
newline db 0x0A

section .bss
outputBuf resb 80