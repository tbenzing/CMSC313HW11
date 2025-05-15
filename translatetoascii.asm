section .data
inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
inputLen equ $ - inputBuf

hexDigits db "0123456789ABCDEF"
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
    movzx ebx, ah                    
    mov bl, byte [hexDigits + ebx]
    mov [edi], bl
    inc edi

    ; Lower nibble
    and al, 0x0F
    movzx ebx, al                    
    mov bl, byte [hexDigits + ebx]
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
    mov eax, 4             ; syscall number for sys_write
    mov ebx, 1             ; file descriptor: stdout
    mov ecx, outputBuf     ; pointer to output buffer
    mov edx, edi
    sub edx, outputBuf     ; length = edi - outputBuf
    int 0x80

    ; exit syscall: sys_exit (eax=1)
    mov eax, 1
    xor ebx, ebx
    int 0x80