//
//  MessageEncoder.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessageEncoder.h"
#import "MessageResponse.h"

static const NSString *DELIMITER = @" ";
static const NSString *MAGIC = @"message";

@implementation MessageEncoder

- (NSString *) encodeMessgeResponse:(MessageResponse *)messageResponse
                              error:(NSError **)error
{
    NSParameterAssert(messageResponse != nil);
    return [NSString stringWithFormat:@"%@%@%@",MAGIC, DELIMITER, messageResponse.message];
}

@end
