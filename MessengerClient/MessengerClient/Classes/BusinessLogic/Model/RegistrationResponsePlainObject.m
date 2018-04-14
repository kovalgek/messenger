//
//  RegistrationResponsePlainObject.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationResponsePlainObject.h"

@implementation RegistrationResponsePlainObject

- (instancetype)initWithRegistrationResponse:(RegistrationResponse *)registrationResponse
{
    self = [super init];
    
    _status = [registrationResponse.status copy];
    
    return self;
}

@end
