//
//  ServicesManager.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 23.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "ServicesManager.h"

#import "AddressUtility.h"
#import "ErrorHelper.h"

static const size_t MAX_WIRE_SIZE = 4096;

//static const int BUFSIZE = 1024;

@interface ServicesManager()
@property (nonatomic, strong) NSMutableArray <id<MessageReceiverType>> *services;
@property (nonatomic, assign) int serverSocket;
@property (nonatomic, strong) id<FramerType> framer;
@property (nonatomic, strong) id<SocketManagerType> socketManager;
@property (nonatomic, assign) BOOL stopMessageLoop;
@end

@implementation ServicesManager

- (instancetype) initWithFramer:(id<FramerType>)framer socketManager:(id<SocketManagerType>)socketManager
{
    self = [super init];
    
    _framer = framer;
    _socketManager = socketManager;
    _services = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) setupTCPServerSocketWithService:(NSString *)service
{
    self.serverSocket = [self.socketManager serverSocketForService:service];
}

- (void) runMessagesLoop
{
    if (self.serverSocket == -1)
    {
        return;
    }
    
    self.stopMessageLoop = NO;
    
    do
    {
        // Wait for a client to connect
        int clientSocket = [self.socketManager clientSocketForServerSocket:self.serverSocket];
        if (clientSocket > 0)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self handleTCPClient: clientSocket];
            });
        }
        
    } while(self.stopMessageLoop);
}

- (void)stopMessagesLoop
{
    self.stopMessageLoop = YES;
}

- (void) handleTCPClient:(int)clientSocket
{
    // Create an input stream from the socket
    FILE *channel = [self.socketManager streamForSocket:clientSocket];
    
    // Receive messages until connection closes
    size_t mSize;
    UInt8 inbuf[MAX_WIRE_SIZE];
    
    while ((mSize = [self.framer getNextMesageFromSocketStream:channel buffer:inbuf bufferSize:MAX_WIRE_SIZE]) > 0)
    {
        NSString *receivedBuffer = [NSString stringWithCString:(char *)inbuf encoding:NSUTF8StringEncoding];
        
        for(id<MessageReceiverType> service in self.services)
        {
            [service receivedBuffer:receivedBuffer forSocket:clientSocket];
        }
    }
}

- (void) addService:(id<MessageReceiverType>)service
{
    [self.services addObject:service];
}

- (void) removeService:(id<MessageReceiverType>)service
{
    [self.services removeObject:service];
}

- (void)sendMessage:(NSString *)message toSocket:(int)socket
{
    const char *buffer = [message UTF8String];
    FILE *channel = [self.socketManager streamForSocket:socket];
    [self.framer putMessageToSocketStream:channel buffer:(UInt8 *)buffer bufferSize:MAX_WIRE_SIZE];
}

- (void)sendMessageToAllUsers:(NSString *)message
{
    
}

@end
