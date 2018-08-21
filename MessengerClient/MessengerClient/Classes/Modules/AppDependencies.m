//
//  RoutersFactory.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "AppDependencies.h"

#import "ServicesManager.h"
#import "DelimiterFramer.h"
#import "SocketHelper.h"

#import "RegistrationRouter.h"
#import "RegistrationService.h"
#import "RegistrationEncoder.h"
#import "RegistrationDecoder.h"

#import "MessagesRouter.h"
#import "MessageService.h"
#import "MessageEncoder.h"
#import "MessageDecoder.h"

@interface AppDependencies()

@property (nonatomic, strong) ServicesManager *servicesManager;
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
    self.servicesManager = [[ServicesManager alloc] initWithFramer:delimiterFramer socketHelper:socketHelper];
    
    // setup service manager
    [self.servicesManager setupTCPClientSocketWithHost:@"127.0.0.1" port:@"5000"];
    
    // ---------------------------
    // create registration service
    RegistrationDecoder *decoder = [[RegistrationDecoder alloc] init];
    RegistrationEncoder *encoder = [[RegistrationEncoder alloc] init];
    RegistrationService *registrationService = [[RegistrationService alloc] initWithEncoder:encoder decoder:decoder];
    
    // add it to service manager
    [self.servicesManager addService:registrationService];
    registrationService.senderDelegate = self.servicesManager;
    
    // crate registration router
    self.registrationRouter = [[RegistrationRouter alloc] initWithService:registrationService];
    
    // ---------------------------
    // crate message service
    MessageDecoder *messageDecoder = [[MessageDecoder alloc] init];
    MessageEncoder *messageEncoder = [[MessageEncoder alloc] init];
    MessageService *messageService = [[MessageService alloc] initWithEncoder:messageEncoder decoder:messageDecoder];
    
    // add it to service manager
    [self.servicesManager addService:messageService];
    messageService.senderDelegate = self.servicesManager;
    
    // crate messages router
    self.messagesRouter = [[MessagesRouter alloc] initWithService:messageService];
    
    // connect routers
    self.registrationRouter.messagesRouter = self.messagesRouter;
    
    // run service manager
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.servicesManager runMessagesLoop];
    });
}

- (void) installRootViewController:(UIWindow *)window
{
    [self.registrationRouter presentInWindow:window];
}

@end
