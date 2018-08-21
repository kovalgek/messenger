//
//  SocketController.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "SocketController.h"
#import "ErrorHelper.h"
#import "ServicesControllerType.h"

static const size_t MAX_WIRE_SIZE = 4096;

@interface SocketController()

@property (nonatomic, strong) id<FramerType> framer;
@property (nonatomic, strong) id<SocketHelperType> socketHelper;
@property (nonatomic, strong) id<ServicesControllerType> serviceController;

@property (nonatomic, assign) int socket;

@end

@implementation SocketController


- (instancetype) initWithFramer:(id<FramerType>)framer
                   socketHelper:(nonnull id<SocketHelperType>)socketHelper
              serviceController:(nonnull id<ServicesControllerType>)serviceController
{
    self = [super init];
    
    _framer = framer;
    _socketHelper = socketHelper;
    _serviceController = serviceController;
    
    return self;
}

- (void) setupTCPClientSocketWithHost:(NSString *)host
                                 port:(NSString *)port
{
    self.socket = [self.socketHelper clientSocketForHost:host port:port];
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
        
        if(!receivedBuffer)
        {
            break;
        }
        
        [self.serviceController notifyServicesWithBuffer:receivedBuffer];
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
