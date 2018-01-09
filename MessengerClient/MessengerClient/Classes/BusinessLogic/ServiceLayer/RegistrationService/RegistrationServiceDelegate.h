//
//  RegistrationServiceDelegate.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class RegistrationResponse;

@protocol RegistrationServiceDelegate <NSObject>

- (void) registrateUserWithPhoneNumber:(NSString *)phoneNumber
                       failedWithError:(NSError *)error;

- (void) didReceiveRegistration:(RegistrationResponse *)registrationResponse;

@end
