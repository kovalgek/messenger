//
//  ServicesManager.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FramerType.h"
#import "MessageReceiverType.h"
#import "MessageSenderType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServicesManager : NSObject <MessageSenderType>
{
    NSMutableArray <id<MessageReceiverType>> *services;
}

@property (nonatomic, strong, readonly) NSMutableArray <id<MessageReceiverType>> *services;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;

- (instancetype) initWithFramer:(id<FramerType>)framer NS_DESIGNATED_INITIALIZER;

- (void) setupTCPClientSocketWithHost:(NSString *)host
                                 port:(NSString *)port;

- (void) runMessagesLoop;

- (void) addService:(id<MessageReceiverType>)service;
- (void) removeService:(id<MessageReceiverType>)service;

@end


NS_ASSUME_NONNULL_END
