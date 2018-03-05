//
//  MockRegistrationServiceDelegate.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationServiceDelegate.h"
#import "RegistrationResponse.h"

@implementation MockRegistrationServiceDelegate

- (void)didReceiveRequest:(RegistrationRequest *)registrationRequest
{
    
}

- (void)didReceiveError:(NSError *)error
{
    self.fetchError = error;
}

@end
