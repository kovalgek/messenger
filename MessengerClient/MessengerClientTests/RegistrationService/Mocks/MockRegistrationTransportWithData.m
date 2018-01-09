//
//  MockRegistrationTransportWithData.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationTransportWithData.h"

@implementation MockRegistrationTransportWithData

- (void)registrateUserWithPhoneNumber:(NSString *)phoneNumber
                              success:(void (^)(NSData *data))success
                              failure:(void (^)(NSError *))failure
{
    success(self.data);
}

@end
