//
//  MockRegistrationEncoderWithError.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 30.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationEncoderWithError.h"

@implementation MockRegistrationEncoderWithError

- (NSString *) encodeRegistrationResponse:(RegistrationResponse *)registrationResponse
                                    error:(NSError **)error
{
    *error = self.error;
    return @"";
}

@end
