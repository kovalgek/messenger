//
//  User.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 05.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber
{
    self = [super  init];
    _phoneNumber = phoneNumber;
    return self;
}

@end
