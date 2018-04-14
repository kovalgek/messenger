//
//  RegistrationPresenterInput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol RegistrationPresenterInput <NSObject>

- (void) viewCreated;
- (void) registerUserWithPhoneNumber:(NSString *)phoneNumber;

@end
