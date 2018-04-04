//
//  SocketManager.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 20.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "SocketHelper.h"
#include <netdb.h>
#import "ErrorHelper.h"
#import "AddressUtility.h"

static const int MAXPENDING = 5; // Maximum outstanding connection requests

@implementation SocketHelper

- (int) serverSocketForService:(NSString *)service
{
    // Construct the server address structure
    struct addrinfo addrCriteria; // Criteria for address match
    memset(&addrCriteria, 0, sizeof(addrCriteria)); // Zero out structure
    addrCriteria.ai_family = AF_UNSPEC; // Any address family
    addrCriteria.ai_flags = AI_PASSIVE; // Accept on any address/port
    addrCriteria.ai_socktype = SOCK_STREAM; // Only stream sockets
    addrCriteria.ai_protocol = IPPROTO_TCP; // Only TCP protocol
    
    struct addrinfo *servAddr; // List of server addresses
    const char *c_service = [service UTF8String];
    int rtnVal = getaddrinfo(NULL, c_service, &addrCriteria, &servAddr);
    if (rtnVal != 0)
    {
        NSString *rtnValStr = [NSString stringWithCString:(char *)gai_strerror(rtnVal) encoding:NSUTF8StringEncoding];
        [ErrorHelper dieWithUserMessage:@"getaddrinfo() failed" detail: rtnValStr];
    }
    int serverSocket = -1;
    for (struct addrinfo *addr = servAddr; addr != NULL; addr = addr->ai_next)
    {
        // Create a TCP socket
        serverSocket = socket(servAddr->ai_family, servAddr->ai_socktype, servAddr->ai_protocol);
        if (serverSocket < 0)
        {
            continue; // Socket creation failed; try next address
        }
        
        // Bind to the local address and set socket to list
        if ((bind(serverSocket, servAddr->ai_addr, servAddr->ai_addrlen) == 0) && (listen(serverSocket, MAXPENDING) == 0))
        {
            // Print local address of socket
            struct sockaddr_storage localAddr;
            socklen_t addrSize = sizeof(localAddr);
            if (getsockname(serverSocket, (struct sockaddr *) &localAddr, &addrSize) < 0)
            {
                [ErrorHelper dieWithSystemMessage:@"getaddrinfo() failed"];
            }
            fputs("Binding to ", stdout);
            [AddressUtility printSocketAddress:(struct sockaddr *)&localAddr stream: stdout];
            fputc('\n', stdout);
            break; // Bind and list successful
        }
        
        close(serverSocket); // Close and try again
        serverSocket = -1;
    }
    
    // Free address list allocated by getaddrinfo()
    freeaddrinfo(servAddr);
    
    return serverSocket;
}

- (int) clientSocketForServerSocket:(int)serverSocket
{
    struct sockaddr_storage clntAddr; // Client address
    // Set length of client address structure (in-out parameter)
    socklen_t clntAddrLen = sizeof(clntAddr);
    
    // Wait for a client to connect
    int clntSock = accept(serverSocket, (struct sockaddr *) &clntAddr, &clntAddrLen);
    if (clntSock < 0)
    {
        [ErrorHelper dieWithSystemMessage: @"accept() failed"];
    }
    
    // clntSock is connected to a client!
    fputs("Handling client ", stdout);
    [AddressUtility printSocketAddress:(struct sockaddr *)&clntAddr stream: stdout];
    fputc('\n', stdout);
    
    return clntSock;
}

// Create an input stream from the socket
- (FILE *)streamForSocket:(int)socket
{
    // Create an input stream from the socket
    FILE *channel = fdopen(socket, "r+");
    if (channel == NULL)
    {
        [ErrorHelper dieWithSystemMessage: @"fdopen() failed"];
    }
    return channel;
}

@end
