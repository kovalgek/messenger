//
//  MessageResponsePlainObject.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageResponsePlainObject : NSObject

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithMessageResponse:(MessageResponse *)messageResponse NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSString *message;

@end

NS_ASSUME_NONNULL_END
