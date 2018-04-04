//
//  SocketHelper.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 04.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "SocketHelper.h"
#include <netdb.h>
#import "ErrorHelper.h"

@implementation SocketHelper

- (int)clientSocketForHost:(NSString *)host port:(NSString *)port
{
    const char *cHost = [host UTF8String];
    const char *cPort = [port UTF8String];
    
    // Tell the system what kind(s) of address info we want
    struct addrinfo addrCriteria; // Criteria for address match
    memset(&addrCriteria, 0, sizeof(addrCriteria)); // Zero out structure
    addrCriteria.ai_family = AF_UNSPEC; // v4 or v6 is OK
    addrCriteria.ai_socktype = SOCK_STREAM; // Only streaming sockets
    addrCriteria.ai_protocol = IPPROTO_TCP; // Only TCP protocol
    
    // Get address(es)
    struct addrinfo *servAddr; // Holder for returned list of server addrs
    int rtnVal = getaddrinfo(cHost, cPort, &addrCriteria, &servAddr);
    if (rtnVal != 0)
    {
        NSString *rtnValStr = [NSString stringWithCString:(char *)gai_strerror(rtnVal) encoding:NSUTF8StringEncoding];
        [ErrorHelper dieWithUserMessage:@"getaddrinfo() failed" detail: rtnValStr];
    }
    
    int clientSocket = -1;
    
    for (struct addrinfo *addr = servAddr; addr != NULL; addr = addr->ai_next)
    {
        // Create a reliable, stream socket using TCP
        clientSocket = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol);
        if (socket < 0)
        {
            continue; // Socket creation failed; try next address
        }
        
        // Establish the connection to the echo server
        if (connect(clientSocket, addr->ai_addr, addr->ai_addrlen) == 0)
        {
            break; // Socket connection succeeded; break and return socket
        }
        
        close(clientSocket); // Socket connection failed; try next address
        clientSocket = -1;
    }
    
    freeaddrinfo(servAddr); // Free addrinfo allocated in getaddrinfo()
    
    return clientSocket;
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
