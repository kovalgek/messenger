//
//  RegistrationDecoderType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class RegistrationRequest;

@protocol RegistrationDecoderType

- (RegistrationRequest *) decodeRegistrationRequestFromBuffer:(NSString *)buffer
                                                        error:(NSError **)error;

@end
