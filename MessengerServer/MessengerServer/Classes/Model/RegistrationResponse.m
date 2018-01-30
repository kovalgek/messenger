//
//  RegistrationResponse.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationResponse.h"

@implementation RegistrationResponse

- (instancetype) initWithStatus:(NSString *)status
{
    self = [super init];
    
    _status = status;
    
    return self;
}

@end
