//
//  RegistrationServiceType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RegistrationEncoderType.h"
#import "RegistrationDecoderType.h"
#import "RegistrationTransportType.h"
#import "RegistrationServiceDelegate.h"

@protocol RegistrationServiceType

@property (nonatomic, strong) id <RegistrationEncoderType> encoder;
@property (nonatomic, strong) id <RegistrationDecoderType> decoder;
@property (nonatomic, strong) id <RegistrationTransportType> transport;

@property (nonatomic, weak) id <RegistrationServiceDelegate> delegate;

- (void) registrateUserWithRegistrationRequest:(RegistrationRequest *)registrationRequest;
- (void) registrateUserWithPhoneNumberFailedWithError:(NSError *)error;

@end
