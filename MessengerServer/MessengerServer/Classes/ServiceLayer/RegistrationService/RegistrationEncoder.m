//
//  RegistrationEncoder.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationEncoder.h"
#import "RegistrationResponse.h"

static const NSString *DELIMITER = @" ";
static const NSString *MAGIC = @"registration";

@implementation RegistrationEncoder

- (NSString *) encodeRegistrationResponse:(RegistrationResponse *)registrationResponse
                                    error:(NSError **)error
{
    NSParameterAssert(registrationResponse != nil);
    return [NSString stringWithFormat:@"%@%@%@",MAGIC, DELIMITER, registrationResponse.status];
}

@end
