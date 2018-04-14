//
//  MessageServiceType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class MessageRequest;

@protocol MessageServiceType <NSObject>

- (void) sendMessageWithMessageRequest:(MessageRequest *)messageRequest;
- (void) sendMessageWithMessageRequestFailedWithError:(NSError *)error;

@end
