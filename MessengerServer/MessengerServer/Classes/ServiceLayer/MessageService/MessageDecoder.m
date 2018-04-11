//
//  MessageDecoder.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessageDecoder.h"
#import "MessageRequest.h"

static NSString *DELIMITER = @" ";
static NSString *MAGIC = @"message";
static NSString *MessageDecoderErrorDomain = @"MessageDecoderErrorDomain";

@implementation MessageDecoder

- (MessageRequest *)decodeMessageRequestFromBuffer:(NSString *)buffer
                                             error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(buffer != nil);
    
    NSArray *tokens = [buffer componentsSeparatedByString:DELIMITER];
    if (tokens.count != 2)
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain: MessageDecoderErrorDomain
                                         code: MessageDecoderInvalidBufferError
                                     userInfo: nil];
        }
        return nil;
    }
    
    NSString *magic = tokens[0];
    if (![magic isEqualToString:MAGIC])
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain: MessageDecoderErrorDomain
                                         code: MessageDecoderCantParseBuffer
                                     userInfo: nil];
        }
        return nil;
    }
    
    NSString *message = tokens[1];
    if (!message.length)
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain: MessageDecoderErrorDomain
                                         code: MessageDecoderMessageIsEmpty
                                     userInfo: nil];
        }
        return nil;
    }
    
    return [[MessageRequest alloc] initWithMessage:message];
}

@end
