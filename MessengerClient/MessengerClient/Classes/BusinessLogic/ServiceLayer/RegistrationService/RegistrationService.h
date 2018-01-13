//
//  RegistrationService.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationServiceType.h"
#import "RegistrationEncoderType.h"
#import "RegistrationDecoderType.h"
#import "RegistrationTransportType.h"
//#import "ServiceType.h"
#import "ServiceType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RegistrationServiceError) {
    RegistrationCode,
};

@interface RegistrationService : NSObject <RegistrationServiceType, ServiceType>

@property (nonatomic, strong) id <RegistrationEncoderType> encoder;
@property (nonatomic, strong) id <RegistrationDecoderType> decoder;
@property (nonatomic, strong) id <RegistrationTransportType> transport;

@property (nonatomic, weak) id <RegistrationServiceDelegate> delegate;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;

- (instancetype) initWithEncoder:(id <RegistrationEncoderType>)encoder
                         decoder:(id <RegistrationDecoderType>)decoder
                       transport:(id <RegistrationTransportType>)transport NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
