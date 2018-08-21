//
//  RoutersFactory.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "AppDependencies.h"

#import "SocketController.h"
#import "DelimiterFramer.h"
#import "SocketHelper.h"
#import "ServicesController.h"

#import "RegistrationRouter.h"
#import "RegistrationService.h"
#import "RegistrationEncoder.h"
#import "RegistrationDecoder.h"

#import "MessagesRouter.h"
#import "MessageService.h"
#import "MessageEncoder.h"
#import "MessageDecoder.h"

@interface AppDependencies()

@property (nonatomic, strong) SocketController *socketController;
@property (nonatomic, strong) RegistrationRouter *registrationRouter;
@property (nonatomic, strong) MessagesRouter *messagesRouter;

@end

@implementation AppDependencies

- (instancetype)init
{
    self = [super init];
    
    [self configureDependencies];
    
    return self;
}

- (void) configureDependencies
{
    // create service manager
    DelimiterFramer *delimiterFramer = [[DelimiterFramer alloc] init];
    SocketHelper *socketHelper = [[SocketHelper alloc] init];
    ServicesController *serviceController = [[ServicesController alloc] init];
    self.socketController = [[SocketController alloc] initWithFramer:delimiterFramer
                                                        socketHelper:socketHelper
                                                   serviceController:serviceController];
    
    // setup service manager
    [self.socketController setupTCPClientSocketWithHost:@"127.0.0.1" port:@"5000"];
    
    // ---------------------------
    // create registration service
    RegistrationDecoder *decoder = [[RegistrationDecoder alloc] init];
    RegistrationEncoder *encoder = [[RegistrationEncoder alloc] init];
    RegistrationService *registrationService = [[RegistrationService alloc] initWithEncoder:encoder decoder:decoder];
    
    // add registration service to service manager
    [serviceController addService:registrationService];
    registrationService.senderDelegate = self.socketController;
    
    // crate registration router
    self.registrationRouter = [[RegistrationRouter alloc] initWithService:registrationService];
    
    // ---------------------------
    // crate message service
    MessageDecoder *messageDecoder = [[MessageDecoder alloc] init];
    MessageEncoder *messageEncoder = [[MessageEncoder alloc] init];
    MessageService *messageService = [[MessageService alloc] initWithEncoder:messageEncoder decoder:messageDecoder];
    
    // add message service to service manager
    [serviceController addService:messageService];
    messageService.senderDelegate = self.socketController;
    
    // crate messages router
    self.messagesRouter = [[MessagesRouter alloc] initWithService:messageService];
    
    // connect routers
    self.registrationRouter.messagesRouter = self.messagesRouter;
    
    // run service manager
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.socketController runMessagesLoop];
    });
}

- (void) installRootViewController:(UIWindow *)window
{
    [self.registrationRouter presentInWindow:window];
}

@end
