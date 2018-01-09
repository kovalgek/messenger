//
//  RegistrationResponse.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationResponse.h"

@implementation RegistrationResponse

- (instancetype) initWithError:(NSError *)error
{
    self = [super init];
    
    _error = error;
    
    return self;
}

@end
