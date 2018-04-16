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
#import "SocketHelperType.h"
#import "UserStorageType.h"

@interface ServicesManager : NSObject <MessageSenderType>

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithFramer:(id<FramerType>)framer
                   socketHelper:(id<SocketHelperType>)socketHelper
                    userStorage:(id<UserStorageType>)userStorage NS_DESIGNATED_INITIALIZER;

- (void) setupTCPServerSocketWithService:(NSString *)service;

- (void) runMessagesLoop;
- (void) stopMessagesLoop;

- (void) addService:(id<MessageReceiverType>)service;
- (void) removeService:(id<MessageReceiverType>)service;

@end
