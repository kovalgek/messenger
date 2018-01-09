//
//  MockRegistrationEncoder.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationEncoder.h"

@implementation MockRegistrationEncoder

- (NSString *) encodePhoneNumber:(NSString *)phoneNumber error:(NSError **)error
{
    self.phoneNumber = phoneNumber;
    return @"";
}

@end
