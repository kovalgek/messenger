//
//  RegistrationDecoder.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationDecoder.h"
#import "RegistrationResponse.h"

static NSString *DELIMITER = @" ";
static NSString *MAGIC = @"registration";
static NSString *RegistrationDecoderErrorDomain = @"RegistrationDecoderErrorDomain";

@implementation RegistrationDecoder

- (RegistrationResponse *)decodeRegistrationResponseFromBuffer:(NSString *)buffer
                                                         error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(buffer != nil);
    
    NSArray *tokens = [buffer componentsSeparatedByString:DELIMITER];
    if (tokens.count != 2)
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain: RegistrationDecoderErrorDomain
                                         code: RegistrationDecoderInvalidBufferError
                                     userInfo: nil];
        }
        return nil;
    }
    
    NSString *magic = tokens[0];
    if (![magic isEqualToString:MAGIC])
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain: RegistrationDecoderErrorDomain
                                         code: RegistrationDecoderCantParseBuffer
                                     userInfo: nil];
        }
        return nil;
    }
    
    NSString *status = tokens[1];
    if (!status.length)
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain: RegistrationDecoderErrorDomain
                                         code: RegistrationDecoderStatusIsEmpty
                                     userInfo: nil];
        }
        return nil;
    }
    
    RegistrationResponse *registrationResponse = [[RegistrationResponse alloc] initWithStatus:status];
    return registrationResponse;
}

@end
