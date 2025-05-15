section .data
inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
inputLen equ $ - inputBuf

hexDigits db "0123456789ABCDEF", 0
newline db 0x0A

section .bss
outputBuf resb 80

section .text
global _start

_start:
    mov esi, inputBuf     ; Source pointer to inputBuf
    mov edi, outputBuf    ; Destination pointer to outputBuf
    mov ecx, inputLen     ; Number of bytes to convert

convert_loop:
    cmp ecx, 0
    je convert_done       ; If done, exit loop

    ; Load byte from input
    mov al, byte [esi]

    ; Upper nibble
    mov ah, al
    shr ah, 4
    and ah, 0x0F
    mov bl, byte [hexDigits + ah]
    mov [edi], bl
    inc edi

    ; Lower nibble
    and al, 0x0F
    mov bl, byte [hexDigits + al]
    mov [edi], bl
    inc edi

    ; Add space
    mov byte [edi], ' '
    inc edi

    inc esi
    dec ecx
    jmp convert_loop

convert_done:
    dec edi
    mov byte [edi], 0x0A   ; newline

    ; write syscall: sys_write (eax=4)
    mov eax, 4
    mov ebx, 1          ; stdout
    mov ecx, outputBuf
    mov edx, edi
    sub edx, outputBuf  ; length = edi - outputBuf
    int 0x80

    ; exit syscall: sys_exit (eax=1)
    mov eax, 1
    xor ebx, ebx
    int 0x80