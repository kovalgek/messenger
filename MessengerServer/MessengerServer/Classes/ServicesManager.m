//
//  ServicesManager.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 23.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "ServicesManager.h"
#include <netdb.h>
#import "AddressUtility.h"
#import "ErrorHelper.h"

static const size_t MAX_WIRE_SIZE = 4096;
static const int MAXPENDING = 5; // Maximum outstanding connection requests
//static const int BUFSIZE = 1024;

@interface ServicesManager()
@property (nonatomic, assign) int serverSocket;
@property (nonatomic, assign) int clientSocket;
@property (nonatomic, strong) id<FramerType> framer;
@end

@implementation ServicesManager

- (instancetype) initWithFramer:(id<FramerType>)framer
{
    self = [super init];
    
    _framer = framer;
    services = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) setupTCPServerSocketWithService:(NSString *)service
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
    self.serverSocket = -1;
    for (struct addrinfo *addr = servAddr; addr != NULL; addr = addr->ai_next)
    {
        // Create a TCP socket
        self.serverSocket = socket(servAddr->ai_family, servAddr->ai_socktype, servAddr->ai_protocol);
        if (self.serverSocket < 0)
        {
            continue; // Socket creation failed; try next address
        }
        
        // Bind to the local address and set socket to list
        if ((bind(self.serverSocket, servAddr->ai_addr, servAddr->ai_addrlen) == 0) && (listen(self.serverSocket, MAXPENDING) == 0))
        {
            // Print local address of socket
            struct sockaddr_storage localAddr;
            socklen_t addrSize = sizeof(localAddr);
            if (getsockname(self.serverSocket, (struct sockaddr *) &localAddr, &addrSize) < 0)
            {
                [ErrorHelper dieWithSystemMessage:@"getaddrinfo() failed"];
            }
            fputs("Binding to ", stdout);
            [AddressUtility printSocketAddress:(struct sockaddr *)&localAddr stream: stdout];
            fputc('\n', stdout);
            break; // Bind and list successful
        }
        
        close(self.serverSocket); // Close and try again
        self.serverSocket = -1;
    }
    
    // Free address list allocated by getaddrinfo()
    freeaddrinfo(servAddr);
}

- (int) acceptTCPConnectionForSocket:(int)serverSocket
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

- (void) addService:(id<MessageReceiverType>)service
{
    [services addObject:service];
}

- (void) removeService:(id<MessageReceiverType>)service
{
    [services removeObject:service];
}

- (void) runMessagesLoop
{
    for (;;)
    {
        // Wait for a client to connect
        int clientSocket = [self acceptTCPConnectionForSocket: self.serverSocket];
        self.clientSocket = clientSocket;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self handleTCPClient: clientSocket];
        });
    }
}

- (void) handleTCPClient:(int)clientSocket
{
    // Create an input stream from the socket
    FILE *channel = fdopen(clientSocket, "r+");
    if (channel == NULL)
    {
        [ErrorHelper dieWithSystemMessage: @"fdopen() failed"];
    }
    
    // Receive messages until connection closes
    size_t mSize;
    UInt8 inbuf[MAX_WIRE_SIZE];
    
    while ((mSize = [self.framer getNextMesageFromSocketStream:channel buffer:inbuf bufferSize:MAX_WIRE_SIZE]) > 0)
    {
        NSString *receivedBuffer = [NSString stringWithCString:(char *)inbuf encoding:NSUTF8StringEncoding];
        
        for(id<MessageReceiverType> service in services)
        {
            [service receivedBuffer:receivedBuffer forSocket:clientSocket];
        }
    }
}

- (void)sendMessage:(NSString *)message
{
    FILE *channel = fdopen(self.clientSocket, "r+");
    if (channel == NULL)
    {
        [ErrorHelper dieWithSystemMessage: @"fdopen() failed"];
    }
    
    const char *buffer = [message UTF8String];
    [self.framer putMessageToSocketStream:channel buffer:(UInt8 *)buffer bufferSize:MAX_WIRE_SIZE];
}

- (void)sendMessageToAllUsers:(NSString *)message
{
    
}

@end
