//
//  RegistrationService.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationServiceDelegate.h"
#import "RegistrationEncoderType.h"
#import "RegistrationDecoderType.h"
#import "MessageReceiverType.h"
#import "MessageSenderType.h"
#import "RegistrationServiceType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RegistrationServiceError) {
    RegistrationCode,
};

@interface RegistrationService : NSObject <MessageReceiverType, RegistrationServiceType>

@property (nonatomic, weak) id <RegistrationServiceDelegate> delegate;
@property (nonatomic, weak) id <MessageSenderType> senderDelegate;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) new NS_UNAVAILABLE;

- (instancetype) initWithEncoder:(id <RegistrationEncoderType>)encoder
                         decoder:(id <RegistrationDecoderType>)decoder NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
