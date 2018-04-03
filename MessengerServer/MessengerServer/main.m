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
#import "SocketManager.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        RegistrationDecoder *decoder = [[RegistrationDecoder alloc] init];
        RegistrationEncoder *encoder = [[RegistrationEncoder alloc] init];
        
        RegistrationService *registrationService = [[RegistrationService alloc] initWithEncoder:encoder decoder:decoder];
        DelimiterFramer *delimiterFramer = [[DelimiterFramer alloc] init];
        SocketManager *socketManager = [[SocketManager alloc] init];
        ServicesManager *servicesManager = [[ServicesManager alloc] initWithFramer:delimiterFramer socketManager:socketManager];
        [servicesManager setupTCPServerSocketWithService:@"5000"];
        [servicesManager addService:registrationService];
        registrationService.senderDelegate = servicesManager;
        [servicesManager runMessagesLoop];
    }
    return 0;
}
