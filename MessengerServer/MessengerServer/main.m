//
//  main.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicesManager.h"
#import "DelimiterFramer.h"
#import "RegistrationService.h"
#import "RegistrationDecoder.h"
#import "RegistrationEncoder.h"
#import "SocketHelper.h"
#import "UserStorage.h"

#import "MessageService.h"
#import "MessageDecoder.h"
#import "MessageEncoder.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSLog(@"Start server....");
        
        UserStorage *userStorage = [[UserStorage alloc] init];
        
        // Create service manager
        DelimiterFramer *delimiterFramer = [[DelimiterFramer alloc] init];
        SocketHelper *socketHelper = [[SocketHelper alloc] init];
        ServicesManager *servicesManager = [[ServicesManager alloc] initWithFramer:delimiterFramer
                                                                      socketHelper:socketHelper
                                                                       userStorage:userStorage];
        
        // Registration
        RegistrationDecoder *decoder = [[RegistrationDecoder alloc] init];
        RegistrationEncoder *encoder = [[RegistrationEncoder alloc] init];
        RegistrationService *registrationService = [[RegistrationService alloc] initWithEncoder:encoder
                                                                                        decoder:decoder
                                                                                    userStorage:userStorage];
        [servicesManager addService:registrationService];
        registrationService.senderDelegate = servicesManager;
        
        // Message
        MessageEncoder *messageEncoder = [[MessageEncoder alloc] init];
        MessageDecoder *messageDecoder = [[MessageDecoder alloc] init];
        MessageService *messageService = [[MessageService alloc] initWithEncoder:messageEncoder
                                                                         decoder:messageDecoder
                                                                     userStorage:userStorage];
        [servicesManager addService:messageService];
        messageService.senderDelegate = servicesManager;
        
        // Setup and run
        [servicesManager setupTCPServerSocketWithService:@"5000"];
        [servicesManager runMessagesLoop];
    }
    return 0;
}
