//
//  RoutersFactory.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "RoutersFactory.h"
#import "RegistrationRouter.h"
#import "MessagesRouter.h"

#import "RegistrationService.h"

#import "ServicesManager.h"
#import "RegistrationDecoder.h"
#import "RegistrationEncoder.h"
#import "DelimiterFramer.h"
#import "SocketHelper.h"

#import "MessagesRouter.h"
#import "MessageService.h"
#import "MessageEncoder.h"
#import "MessageDecoder.h"

@interface RoutersFactory()
@property (nonatomic, strong) ServicesManager *servicesManager;
@property (nonatomic, strong) RegistrationRouter *registrationRouter;
@property (nonatomic, strong) MessagesRouter *messagesRouter;
@end

@implementation RoutersFactory

- (instancetype)init
{
    self = [super init];
    [self configureDependencies];
    return self;
}

- (void) configureDependencies
{
    DelimiterFramer *delimiterFramer = [[DelimiterFramer alloc] init];
    SocketHelper *socketHelper = [[SocketHelper alloc] init];
    self.servicesManager = [[ServicesManager alloc] initWithFramer:delimiterFramer socketHelper:socketHelper];;
    [self.servicesManager setupTCPClientSocketWithHost:@"127.0.0.1" port:@"5000"];
 
    RegistrationDecoder *decoder = [[RegistrationDecoder alloc] init];
    RegistrationEncoder *encoder = [[RegistrationEncoder alloc] init];
    RegistrationService *registrationService = [[RegistrationService alloc] initWithEncoder:encoder decoder:decoder];
    [self.servicesManager addService:registrationService];
    registrationService.senderDelegate = self.servicesManager;
    
    self.registrationRouter = [[RegistrationRouter alloc] initWithService:registrationService];
    
    MessageDecoder *messageDecoder = [[MessageDecoder alloc] init];
    MessageEncoder *messageEncoder = [[MessageEncoder alloc] init];
    MessageService *messageService = [[MessageService alloc] initWithEncoder:messageEncoder decoder:messageDecoder];
    [self.servicesManager addService:messageService];
    messageService.senderDelegate = self.servicesManager;
    
    self.messagesRouter = [[MessagesRouter alloc] initWithService:messageService];
    
    self.registrationRouter.messagesRouter = self.messagesRouter;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.servicesManager runMessagesLoop];
    });
}

- (void) installRootViewController:(UIWindow *)window
{
    [self.registrationRouter presentInWindow:window];
}

@end
