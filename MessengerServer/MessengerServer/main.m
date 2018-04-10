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

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        RegistrationDecoder *decoder = [[RegistrationDecoder alloc] init];
        RegistrationEncoder *encoder = [[RegistrationEncoder alloc] init];
        UserStorage *userStorage = [[UserStorage alloc] init];
        RegistrationService *registrationService = [[RegistrationService alloc] initWithEncoder:encoder
                                                                                        decoder:decoder
                                                                                    userStorage:userStorage];
        DelimiterFramer *delimiterFramer = [[DelimiterFramer alloc] init];
        SocketHelper *socketHelper = [[SocketHelper alloc] init];
        ServicesManager *servicesManager = [[ServicesManager alloc] initWithFramer:delimiterFramer socketHelper:socketHelper];
        [servicesManager setupTCPServerSocketWithService:@"5000"];
        [servicesManager addService:registrationService];
        registrationService.senderDelegate = servicesManager;
        [servicesManager runMessagesLoop];
    }
    return 0;
}
