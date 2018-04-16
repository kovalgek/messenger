//
//  MessagesRouter.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagesRouterInput.h"
#import "MessageServiceType.h"

@interface MessagesRouter : NSObject <MessagesRouterInput>

- (instancetype)initWithService:(id<MessageServiceType>)service;

@end
