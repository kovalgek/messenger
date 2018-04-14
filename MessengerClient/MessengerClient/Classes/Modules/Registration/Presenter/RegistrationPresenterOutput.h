//
//  RegistrationPresenterOutput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RegistrationResponsePlainObject.h"

@protocol RegistrationPresenterOutput <NSObject>

- (void)presentRegistrationResponse:(RegistrationResponsePlainObject *)registrationResponse;
- (void)presentError:(NSString *)message;

@end
