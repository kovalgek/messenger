//
//  RegistrationRequest.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationRequest.h"

@implementation RegistrationRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber
{
    self = [super  init];
    
    _phoneNumber = phoneNumber;

    return self;
}

@end
