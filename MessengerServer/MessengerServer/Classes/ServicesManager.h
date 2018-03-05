//
//  ServicesManager.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 23.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageReceiverType.h"
#import "MessageSenderType.h"
#import "FramerType.h"

@interface ServicesManager : NSObject <MessageSenderType>
{
    @protected
    NSMutableArray <id<MessageReceiverType>> *services;
}

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithFramer:(id<FramerType>)framer NS_DESIGNATED_INITIALIZER;

- (void) setupTCPServerSocketWithService:(NSString *)service;
- (void) runMessagesLoop;

- (void) addService:(id<MessageReceiverType>)service;
- (void) removeService:(id<MessageReceiverType>)service;

@end
