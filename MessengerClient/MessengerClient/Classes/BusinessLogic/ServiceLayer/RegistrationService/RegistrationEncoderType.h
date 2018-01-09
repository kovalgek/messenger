//
//  RegistrationEncoderType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol RegistrationEncoderType

- (NSString *) encodePhoneNumber:(NSString *)phoneNumber
                           error:(NSError **)error;

@end

