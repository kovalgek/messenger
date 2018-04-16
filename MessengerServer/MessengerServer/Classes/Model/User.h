//
//  User.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 05.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, assign) int socket;

@property (nonatomic, copy, readonly) NSString *phoneNumber;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
