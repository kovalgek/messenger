//
//  RegistrationInteractorInput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol RegistrationInteractorInput <NSObject>

- (void) registerWithPhoneNumber:(NSString *)phoneNumber;

@end
