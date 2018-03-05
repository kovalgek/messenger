//
//  MockRegistrationDecoder.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "MockRegistrationDecoder.h"

@implementation MockRegistrationDecoder

- (RegistrationRequest *)decodeRegistrationRequestFromBuffer:(NSString *)buffer
                                                       error:(NSError *__autoreleasing *)error
{
    self.buffer = buffer;
    if (error)
    {
        *error = self.errorToSet;
    }
    return self.dataToReturn;
}

@end
