//
//  MockRegistrationTransportWithError.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationTransportWithError.h"

@implementation MockRegistrationTransportWithError

- (void)registrateUserWithPhoneNumber:(NSString *)phoneNumber
                              success:(void (^)(void))success
                              failure:(void (^)(NSError *))failure
{
    failure(self.error);
}

@end
