//
//  MockRegistrationTransport.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationTransport.h"

@implementation MockRegistrationTransport

- (void) registrateUserWithBuffer:(NSString *)buffer
{
    self.wasAskedToRegisterUser = YES;
}

@end
