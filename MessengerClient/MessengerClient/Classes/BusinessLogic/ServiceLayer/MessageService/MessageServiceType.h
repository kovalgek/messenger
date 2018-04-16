//
//  MessageServiceType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class MessageRequest;
@protocol MessageServiceDelegate;
@protocol MessageSenderType;

@protocol MessageServiceType <NSObject>

- (void) sendMessageWithMessageRequest:(MessageRequest *)messageRequest;
- (void) sendMessageWithMessageRequestFailedWithError:(NSError *)error;

@property (nonatomic, weak) id <MessageServiceDelegate> delegate;
@property (nonatomic, weak) id <MessageSenderType> senderDelegate;

@end
