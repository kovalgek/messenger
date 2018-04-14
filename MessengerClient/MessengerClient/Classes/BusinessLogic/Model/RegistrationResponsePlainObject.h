//
//  RegistrationResponsePlainObject.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationResponsePlainObject : NSObject

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;
- (instancetype) initWithRegistrationResponse:(RegistrationResponse *)registrationResponse NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSString *status;

@end

NS_ASSUME_NONNULL_END
