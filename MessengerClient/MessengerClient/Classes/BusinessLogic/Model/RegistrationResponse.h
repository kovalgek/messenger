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

@property (nonatomic, copy, readonly) NSString *status;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;

- (instancetype) initWithStatus:(NSString *)status NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
