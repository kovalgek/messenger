//
//  MessageSenderType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 13.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol MessageSenderType <NSObject>
- (void) sendMessage:(NSString *)message toSocket:(int)socket;
- (void) sendMessageToAllUsers:(NSString *)message;
@end
