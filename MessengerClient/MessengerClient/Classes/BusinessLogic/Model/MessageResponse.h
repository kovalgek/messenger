//
//  MessageResponse.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageResponse : NSObject

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithMessage:(NSString *)message NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSString *message;

@end

NS_ASSUME_NONNULL_END
