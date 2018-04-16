//
//  MessagesPresenterOutput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
@class MessageResponsePlainObject;
@protocol MessageCellType;

@protocol MessagesPresenterOutput <NSObject>

- (void)presentMessageResponse:(MessageResponsePlainObject *)messageResponse;
- (void)presentError:(NSString *)message;

- (void)configureMessageCell:(id<MessageCellType>)view atIndex:(NSUInteger)index;;
@property (readonly, nonatomic, assign) NSUInteger messagesCount;

@end
