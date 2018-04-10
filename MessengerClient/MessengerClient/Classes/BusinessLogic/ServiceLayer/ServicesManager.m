//
//  ServicesManager.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "ServicesManager.h"
#import "ErrorHelper.h"

static const size_t MAX_WIRE_SIZE = 4096;

@interface ServicesManager()
@property (nonatomic, strong) id<FramerType> framer;
@property (nonatomic, strong) id<SocketHelperType> socketHelper;
@property (nonatomic, assign) int socket;
@property (nonatomic, strong) NSMutableArray <id<MessageReceiverType>> *services;
@end

@implementation ServicesManager


- (instancetype) initWithFramer:(id<FramerType>)framer socketHelper:(nonnull id<SocketHelperType>)socketHelper
{
    self = [super init];
    
    _framer = framer;
    _socketHelper = socketHelper;
    _services = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) setupTCPClientSocketWithHost:(NSString *)host
                                 port:(NSString *)port
{
    self.socket = [self.socketHelper clientSocketForHost:host port:port];
    NSLog(@"self.socket=%d",self.socket);
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
    FILE *channel = [self.socketHelper streamForSocket:self.socket];
    
    size_t mSize;
    UInt8 inbuf[MAX_WIRE_SIZE];
    
    // Receive and print response
    while ((mSize = [self.framer getNextMesageFromSocketStream:channel buffer:inbuf bufferSize:MAX_WIRE_SIZE]) > 0)
    {
        NSString *receivedBuffer = [[NSString alloc] initWithBytes:inbuf length:mSize encoding:NSUTF8StringEncoding];
        NSLog(@"receivedBuffer=%@",receivedBuffer);
        for(id<MessageReceiverType> service in self.services)
        {
            [service receivedBuffer:receivedBuffer];
        }
    }
}

- (void)sendMessage:(NSString *)message
{
    FILE *channel = [self.socketHelper streamForSocket:self.socket];
    const char *buffer = [message UTF8String];
    size_t bufferSize = strlen(buffer) * sizeof(char);
    [self.framer putMessageToSocketStream:channel buffer:(UInt8 *)buffer bufferSize:bufferSize];
}


@end
