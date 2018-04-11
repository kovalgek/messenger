//
//  MessageService.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageServiceDelegate.h"
#import "MessageSenderType.h"
#import "MessageResponse.h"
#import "MessageEncoderType.h"
#import "MessageDecoderType.h"
#import "UserStorageType.h"
#import "MessageReceiverType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MessageServiceError) {
    MessageCode,
};

@interface MessageService : NSObject <MessageReceiverType>

@property (nonatomic, weak) id <MessageServiceDelegate> serviceDelegate;
@property (nonatomic, weak) id <MessageSenderType> senderDelegate;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithEncoder:(id <MessageEncoderType>)encoder
                         decoder:(id <MessageDecoderType>)decoder
                     userStorage:(id <UserStorageType>)userStorage NS_DESIGNATED_INITIALIZER;

- (void) sendMessageResponseBackToUsers:(MessageResponse *)messageResponse;
- (void) sendMessageResponseBackToUserFailedWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
