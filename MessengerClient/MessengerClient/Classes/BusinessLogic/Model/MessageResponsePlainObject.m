//
//  MessageResponsePlainObject.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessageResponsePlainObject.h"

@implementation MessageResponsePlainObject

- (instancetype)initWithMessageResponse:(MessageResponse *)messageResponse
{
    self = [super init];
    _message = [messageResponse.message copy];
    return self;
}

@end
