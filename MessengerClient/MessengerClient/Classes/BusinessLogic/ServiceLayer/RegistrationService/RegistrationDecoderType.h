//
//  RegistrationDecoderType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class RegistrationResponse;

@protocol RegistrationDecoderType

- (RegistrationResponse *) decodeRegistrationResponseFromBuffer:(NSString *)buffer
                                                          error:(NSError **)error;

@end
