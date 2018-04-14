//
//  RegistrationServiceType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class RegistrationRequest;
@protocol RegistrationServiceDelegate;
@protocol MessageSenderType;

@protocol RegistrationServiceType <NSObject>

- (void) registrateUserWithRegistrationRequest:(RegistrationRequest *)registrationRequest;
- (void) registrateUserWithPhoneNumberFailedWithError:(NSError *)error;

@property (nonatomic, weak) id <RegistrationServiceDelegate> delegate;
@property (nonatomic, weak) id <MessageSenderType> senderDelegate;

@end
