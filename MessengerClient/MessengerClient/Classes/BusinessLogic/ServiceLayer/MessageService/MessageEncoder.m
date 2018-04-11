//
//  MessageEncoder.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessageEncoder.h"
#import "MessageRequest.h"

static const NSString *DELIMITER = @" ";
static const NSString *MAGIC = @"message";

@implementation MessageEncoder

- (NSString *) encodeMessageRequest:(MessageRequest *)messageRequest
                              error:(NSError **)error
{
    NSParameterAssert(messageRequest != nil);
    return [NSString stringWithFormat:@"%@%@%@",MAGIC, DELIMITER, messageRequest.message];
}

@end
