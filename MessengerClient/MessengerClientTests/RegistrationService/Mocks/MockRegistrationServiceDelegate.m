//
//  MockRegistrationServiceDelegate.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationServiceDelegate.h"

@implementation MockRegistrationServiceDelegate

- (void) registrateUserWithPhoneNumber:(NSString *)phoneNumber
                       failedWithError:(NSError *)error
{
    self.fetchError = error;
}

- (void)didReceiveRegistration:(RegistrationResponse *)registrationResponse
{
    
}

@end
