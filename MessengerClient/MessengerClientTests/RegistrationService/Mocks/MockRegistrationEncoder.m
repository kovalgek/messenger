//
//  MockRegistrationEncoder.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationEncoder.h"
#import "RegistrationRequest.h"

@implementation MockRegistrationEncoder

- (NSString *) encodeRegistrationRequest:(RegistrationRequest *)registrationRequest
                                   error:(NSError **)error
{
    self.phoneNumber = registrationRequest.phoneNumber;
    return @"";
}

@end
