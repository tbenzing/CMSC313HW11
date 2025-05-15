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
    mov esi, inputBuf     ; source pointer to inputBuf
    mov edi, outputBuf    ; destination pointer to outputBuf
    mov ecx, inputLen     ; number of bytes to convert

;; convert each bypte in inputBuf to its 2digit ascii hex representation
;; store result in outputBuf, adding a space after each byte

convert_loop:
    cmp ecx, 0
    je convert_done      ; exit loop once all input bytes are processed 

    ;; load one byte from input buffer
    mov al, byte [esi]

    ;; isolate and convert the upper nibble to ascii hex
    mov ah, al
    shr ah, 4             ; shift right to move upper nibble into lower bits
    and ah, 0x0F          ; mask to ensure only 4 bits remain
    movzx ebx, ah         ; zero-extend to safely use as index
    mov bl, byte [hexDigits + ebx] ; look up ascii character
    mov [edi], bl         ; store ascii character in output buffer
    inc edi

    ;; isolate and convert the lower nibble of the byte to ascii hex, same process as upper nibble
    and al, 0x0F
    movzx ebx, al
    mov bl, byte [hexDigits + ebx]
    mov [edi], bl
    inc edi

    ;; add space
    mov byte [edi], ' '
    inc edi

    inc esi
    dec ecx
    jmp convert_loop

convert_done:
    ;; overwrite trailing space with a newline
    mov byte [edi], 0x0A
    inc edi

    ;; write outputBuf to the terminal
    mov eax, 4             
    mov ebx, 1             
    mov ecx, outputBuf     
    mov edx, edi
    sub edx, outputBuf     
    int 0x80

    ;; exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80