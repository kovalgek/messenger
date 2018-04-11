//
//  MessageResponse.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessageResponse.h"

@implementation MessageResponse

- (instancetype) initWithMessage:(NSString *)message
{
    self = [super  init];
    
    _message = message;
    
    return self;
}

@end
