//
//  RegistrationDecoder.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationDecoder.h"
#import "RegistrationRequest.h"

static NSString *DELIMITER = @" ";
static NSString *MAGIC = @"registration";
static NSString *RegistrationDecoderErrorDomain = @"RegistrationDecoderErrorDomain";

@implementation RegistrationDecoder

- (RegistrationRequest *)decodeRegistrationRequestFromBuffer:(NSString *)buffer
                                                       error:(NSError *__autoreleasing *)error
{
    NSLog(@"decodeRegistrationRequestFromBuffer buffer=%@",buffer);
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
    NSLog(@"decodeRegistrationRequestFromBuffer magic=%@",magic);
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
    
    NSString *phoneNumber = tokens[1];
    NSLog(@"decodeRegistrationRequestFromBuffer phoneNumber=%@",phoneNumber);
    if (!phoneNumber.length)
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain: RegistrationDecoderErrorDomain
                                         code: RegistrationDecoderStatusIsEmpty
                                     userInfo: nil];
        }
        return nil;
    }
    NSLog(@"decodeRegistrationRequestFromBuffer last");
    RegistrationRequest *registrationRequest = [[RegistrationRequest alloc] initWithPhoneNumber:phoneNumber];
    return registrationRequest;
}

@end
