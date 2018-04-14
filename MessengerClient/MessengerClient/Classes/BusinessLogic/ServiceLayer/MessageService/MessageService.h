//
//  MessageService.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageReceiverType.h"
#import "MessageSenderType.h"
#import "MessageServiceDelegate.h"
#import "MessageEncoderType.h"
#import "MessageDecoderType.h"
#import "MessageServiceType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MessageServiceError) {
    MessageCode,
};

@interface MessageService : NSObject <MessageReceiverType, MessageServiceType>

@property (nonatomic, weak) id <MessageServiceDelegate> delegate;
@property (nonatomic, weak) id <MessageSenderType> senderDelegate;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithEncoder:(id <MessageEncoderType>)encoder
                         decoder:(id <MessageDecoderType>)decoder NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
