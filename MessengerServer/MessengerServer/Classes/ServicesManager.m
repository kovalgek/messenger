//
//  ServicesManager.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 23.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "ServicesManager.h"
#include <netdb.h>

static const size_t MAX_WIRE_SIZE = 4096;
static const int MAXPENDING = 5; // Maximum outstanding connection requests
static const int BUFSIZE = 1024;

@interface ServicesManager()
@property (nonatomic, assign) int serverSocket;
@property (nonatomic, strong) id<FramerType> framer;
@property (nonatomic, strong) NSMutableArray <id<MessageReceiverType>> *services;
@end

@implementation ServicesManager

- (instancetype) initWithFramer:(id<FramerType>)framer
{
    self = [super init];
    
    _framer = framer;
    _services = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) setupTCPServerSocket:(NSString *)service
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
        [self dieWithUserMessage:@"getaddrinfo() failed"
                          detail: rtnValStr];
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
                [self dieWithSystemMessage:@"getaddrinfo() failed"];
            }
            fputs("Binding to ", stdout);
            printSocketAddress((struct sockaddr *) &localAddr, stdout);
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
        [self dieWithSystemMessage: @"accept() failed"];
    }
    
    // clntSock is connected to a client!
    fputs("Handling client ", stdout);
    printSocketAddress((struct sockaddr *) &clntAddr, stdout);
    fputc('\n', stdout);
    
    return clntSock;
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
    for (;;)
    {
        // Wait for a client to connect
        int clientSocket = [self acceptTCPConnectionForSocket: self.serverSocket];
        
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
        [self dieWithSystemMessage: @"fdopen() failed"];
    }
    
    // save socket to list
//    User *newUser = addUserWithSocket(clntSocket, "", "");
//    if (!newUser)
//    {
//        dieWithSystemMessage("can't save socket to list");
//    }
    
    // Receive messages until connection closes
    size_t mSize;
    UInt8 inbuf[MAX_WIRE_SIZE];
    
    while ((mSize = [self.framer getNextMesageFromSocketStream:channel buffer:inbuf bufferSize:MAX_WIRE_SIZE]) > 0)
    {
        NSString *receivedBuffer = [NSString stringWithCString:(char *)inbuf encoding:NSUTF8StringEncoding];
        
        for(id<MessageReceiverType> service in self.services)
        {
            [service receivedBuffer:receivedBuffer];
        }
    }
    
//    Login login;
//    ClientMessage clientMessage;
//
//    while ((mSize = getNextMesage(channel, inBuf, MAX_WIRE_SIZE)) > 0)
//    {
//        memset(&login, 0, sizeof(Login));
//        memset(&clientMessage, 0, sizeof(ClientMessage));
//
//        printf("Received message (%zu bytes)\n", mSize);
//
//        if (decodeLogin(inBuf, mSize, &login))
//        {
//            printf("login: %s\n", login.value);
//
//            uuid_t uuid;
//            uuid_generate_time(uuid);
//            char uuid_str[37];
//            uuid_unparse_lower(uuid, uuid_str);
//            printf("generate uuid=%s\n", uuid_str);
//
//            // save logged-in user to struct
//            strcpy(newUser->name, login.value);
//            strcpy(newUser->token, uuid_str);
//
//            printUsers();
//
//            Token token;
//            memset(&token, 0, sizeof(Token));
//            strcpy(token.value, uuid_str);
//
//            uint8_t outBuf[MAX_WIRE_SIZE];
//            mSize = encodeToken(&token, outBuf, MAX_WIRE_SIZE);
//            if (putMessage(outBuf, mSize, channel) < 0)
//            {
//                fputs("Error framing/outputting message\n", stderr);
//                break;
//            }
//            else
//            {
//                printf("Processed login:%s token:%s\n", login.value, token.value);
//            }
//            //fflush(channel);
//        }
//        else if (decodeClientMessage(inBuf, mSize, &clientMessage))
//        {
//            User *user = findByToken(clientMessage.token);
//            if (!user)
//            {
//                continue;
//            }
//
//            ServerMessage serverMessage;
//            memset(&serverMessage, 0, sizeof(ServerMessage));
//            strcpy(serverMessage.name, user->name);
//            strcpy(serverMessage.text, clientMessage.text);
//
//
//            uint8_t outBuf[MAX_WIRE_SIZE];
//            mSize = encodeServerMessage(&serverMessage, outBuf, MAX_WIRE_SIZE);
//
//            User *currentUser = getUserHead();
//
//            while (currentUser)
//            {
//                FILE *currentUserChannel = fdopen(currentUser->socket, "r+");
//                if (currentUserChannel == NULL)
//                {
//                    dieWithSystemMessage("fdopen() failed");
//                }
//
//                if (putMessage(outBuf, mSize, currentUserChannel) < 0)
//                {
//                    fputs("Error framing/outputting message\n", stderr);
//                    break;
//                }
//                else
//                {
//                    printf("Processed clientMessage name:%s text:%s\n", serverMessage.name, serverMessage.text);
//                }
//
//                currentUser = currentUser->next;
//            }
//        }
//        else
//        {
//            fputs("Parse error, closing connection.\n", stderr);
//            break;
//        }
//        memset(&inBuf, 0, MAX_WIRE_SIZE);
//    }
//    puts("Client finished");
}

- (void)sendMessage:(NSString *)message
{
    FILE *channel = fdopen(self.serverSocket, "r+");
    if (channel == NULL)
    {
        [self dieWithSystemMessage: @"fdopen() failed"];
    }
    
    const char *buffer = [message UTF8String];
    
    [self.framer putMessageToSocketStream:channel buffer:(UInt8 *)buffer bufferSize:MAX_WIRE_SIZE];
}

- (void)sendMessageToAllUsers:(NSString *)message
{
    
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
