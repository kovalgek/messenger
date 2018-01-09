//
//  RegistrationResponse.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationResponse : NSObject

@property (nonatomic, copy, nullable) NSError *error;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;

- (instancetype) initWithError:(nullable NSError *)error NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
