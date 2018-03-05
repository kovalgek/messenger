//
//  MockRegistrationEncoder.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationEncoder.h"
#import "RegistrationResponse.h"

@implementation MockRegistrationEncoder

- (NSString *) encodeRegistrationResponse:(RegistrationResponse *)registrationResponse
                                    error:(NSError **)error;
{
    self.status = registrationResponse.status;
    return @"";
}

@end
