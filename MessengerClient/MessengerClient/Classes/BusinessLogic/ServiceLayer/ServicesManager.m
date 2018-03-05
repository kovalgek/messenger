//
//  ServicesManager.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "ServicesManager.h"
#include <netdb.h>

static const size_t MAX_WIRE_SIZE = 4096;

@interface ServicesManager()
@property (nonatomic, assign) int socket;
@property (nonatomic, strong) id<FramerType> framer;
@property (nonatomic, strong, readwrite) NSMutableArray <id<MessageReceiverType>> *services;
@end

@implementation ServicesManager


- (instancetype) initWithFramer:(id<FramerType>)framer
{
    self = [super init];
    
    _framer = framer;
    _services = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) setupTCPClientSocketWithHost:(NSString *)host
                                 port:(NSString *)port
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
        [self dieWithUserMessage:@"getaddrinfo() failed"
                          detail: rtnValStr];
    }
    
    self.socket = -1;
    for (struct addrinfo *addr = servAddr; addr != NULL; addr = addr->ai_next)
    {
        // Create a reliable, stream socket using TCP
        self.socket = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol);
        if (self.socket < 0)
        {
            continue; // Socket creation failed; try next address
        }
        
        // Establish the connection to the echo server
        if (connect(self.socket, addr->ai_addr, addr->ai_addrlen) == 0)
        {
            break; // Socket connection succeeded; break and return socket
        }
        
        close(self.socket); // Socket connection failed; try next address
        self.socket = -1;
    }
    
    freeaddrinfo(servAddr); // Free addrinfo allocated in getaddrinfo()
}

- (void) addService:(id<MessageReceiverType>)service
{
    [self.services addObject:service];
}

- (void) removeService:(id<MessageReceiverType>)service
{
    [self.services removeObject:service];
}

- (void) runMessagesLoop
{
    size_t mSize;
    
    UInt8 inbuf[MAX_WIRE_SIZE];
    
    FILE *channel = fdopen(self.socket, "r+");
    if (channel == NULL)
    {
        [self dieWithSystemMessage: @"fdopen() failed"];
    }
    
    // Receive and print response
    while ((mSize = [self.framer getNextMesageFromSocketStream:channel buffer:inbuf bufferSize:MAX_WIRE_SIZE]) > 0)
    {
        NSString *receivedBuffer = [NSString stringWithCString:(char *)inbuf encoding:NSUTF8StringEncoding];
        NSLog(@"receivedBuffer=%@",receivedBuffer);
        for(id<MessageReceiverType> service in self.services)
        {
            [service receivedBuffer:receivedBuffer];
        }
    }
}

- (void)sendMessage:(NSString *)message
{
    FILE *channel = fdopen(self.socket, "r+");
    if (channel == NULL)
    {
        [self dieWithSystemMessage: @"fdopen() failed"];
    }
    
    const char *buffer = [message UTF8String];
    
    [self.framer putMessageToSocketStream:channel buffer:(UInt8 *)buffer bufferSize:MAX_WIRE_SIZE];
}

- (void) dieWithUserMessage:(NSString *)message
                     detail:(NSString *)detail
{
    NSLog(@"%@: %@\n",message, detail);
    exit(1);
}

- (void) dieWithSystemMessage:(NSString *)message
{
    perror([message UTF8String]);
    exit(1);
}

@end
