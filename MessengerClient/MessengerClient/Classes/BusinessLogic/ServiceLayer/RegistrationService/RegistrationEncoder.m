//
//  RegistrationEncoder.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationEncoder.h"
#import "RegistrationRequest.h"

static const NSString *DELIMITER = @" ";
static const NSString *MAGIC = @"registration";

@implementation RegistrationEncoder

- (NSString *) encodeRegistrationRequest:(RegistrationRequest *)registrationRequest
                                   error:(NSError **)error
{
    NSParameterAssert(registrationRequest != nil);
    return [NSString stringWithFormat:@"%@%@%@",MAGIC, DELIMITER, registrationRequest.phoneNumber];
}

@end
