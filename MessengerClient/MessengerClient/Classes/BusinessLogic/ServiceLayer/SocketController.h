//
//  SocketController.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FramerType.h"
#import "MessageReceiverType.h"
#import "MessageSenderType.h"
#import "SocketHelperType.h"

@protocol ServicesControllerType;

NS_ASSUME_NONNULL_BEGIN

@interface SocketController : NSObject <MessageSenderType>

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithFramer:(id<FramerType>)framer
                   socketHelper:(id<SocketHelperType>)socketHelper
              serviceController:(id<ServicesControllerType>) serviceController NS_DESIGNATED_INITIALIZER;

- (void) setupTCPClientSocketWithHost:(NSString *)host
                                 port:(NSString *)port;

- (void) runMessagesLoop;

@end

NS_ASSUME_NONNULL_END
