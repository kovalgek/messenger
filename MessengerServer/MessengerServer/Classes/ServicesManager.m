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
#import "User.h"

static const size_t MAX_WIRE_SIZE = 4096;

//static const int BUFSIZE = 1024;

@interface ServicesManager()
@property (nonatomic, strong) NSMutableArray <id<MessageReceiverType>> *services;
@property (nonatomic, assign) int serverSocket;
@property (nonatomic, strong) id<FramerType> framer;
@property (nonatomic, strong) id<SocketHelperType> socketHelper;
@property (nonatomic, strong) id <UserStorageType> userStorage;
@property (nonatomic, assign) BOOL stopMessageLoop;
@end

@implementation ServicesManager

- (instancetype) initWithFramer:(id<FramerType>)framer
                   socketHelper:(id<SocketHelperType>)socketHelper
                    userStorage:(id<UserStorageType>)userStorage
{
    self = [super init];
    
    _framer = framer;
    _socketHelper = socketHelper;
    _userStorage = userStorage;
    _services = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) setupTCPServerSocketWithService:(NSString *)service
{
    self.serverSocket = [self.socketHelper serverSocketForService:service];
    self.stopMessageLoop = NO;
}

- (void) runMessagesLoop
{
    if (self.serverSocket == -1)
    {
        return;
    }
    
    do
    {
        // Wait for a client to connect
        int clientSocket = [self.socketHelper clientSocketForServerSocket:self.serverSocket];
        if (clientSocket > 0)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self handleTCPClient: clientSocket];
            });
        }
        
    } while(!self.stopMessageLoop);
}

- (void)stopMessagesLoop
{
    self.stopMessageLoop = YES;
}

- (void) handleTCPClient:(int)clientSocket
{
    // Create an input stream from the socket
    FILE *channel = [self.socketHelper streamForSocket:clientSocket];
    
    // Receive messages until connection closes
    size_t mSize;
    UInt8 inbuf[MAX_WIRE_SIZE];
    
    while ((mSize = [self.framer getNextMesageFromSocketStream:channel buffer:inbuf bufferSize:MAX_WIRE_SIZE]) > 0)
    {
        NSString *receivedBuffer = [[NSString alloc] initWithBytes:inbuf length:mSize encoding:NSUTF8StringEncoding];
        NSLog(@"receivedBuffer=%@",receivedBuffer);
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
    FILE *channel = [self.socketHelper streamForSocket:socket];
    const char *buffer = [message UTF8String];
    size_t bufferSize = strlen(buffer) * sizeof(char);
    [self.framer putMessageToSocketStream:channel buffer:(UInt8 *)buffer bufferSize:bufferSize];
}

- (void)sendMessageToAllUsers:(NSString *)message
{
    for(User *user in self.userStorage.allUsers)
    {
        FILE *channel = [self.socketHelper streamForSocket:user.socket];
        const char *buffer = [message UTF8String];
        size_t bufferSize = strlen(buffer) * sizeof(char);
        [self.framer putMessageToSocketStream:channel buffer:(UInt8 *)buffer bufferSize:bufferSize];
    }
}

@end
