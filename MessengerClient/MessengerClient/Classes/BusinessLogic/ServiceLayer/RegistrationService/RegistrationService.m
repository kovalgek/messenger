//
//  RegistrationService.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationService.h"

static NSString *RegistrationServiceFailedError = @"RegistrationServiceFailedError";

@interface RegistrationService()
@property (nonatomic, strong) id <RegistrationEncoderType> encoder;
@property (nonatomic, strong) id <RegistrationDecoderType> decoder;
@end

@implementation RegistrationService

- (instancetype) initWithEncoder:(id <RegistrationEncoderType>)encoder
                         decoder:(id <RegistrationDecoderType>)decoder
{
    self = [super init];
    
    _encoder = encoder;
    _decoder = decoder;
    
    return self;
}

- (void)setDelegate:(id<RegistrationServiceDelegate>)delegate
{
    if (delegate && ![delegate conformsToProtocol: @protocol(RegistrationServiceDelegate)])
    {
        [[NSException exceptionWithName: NSInvalidArgumentException
                                 reason: @"Delegate object does not conform to the delegate protocol"
                               userInfo: nil] raise];
    }
    _delegate = delegate;
}

- (void) registrateUserWithRegistrationRequest:(RegistrationRequest *)registrationRequest
{
    NSError *error = nil;
    NSString *buffer = [self.encoder encodeRegistrationRequest:registrationRequest error:&error];
    
    if (error)
    {
        [self tellDelegateAboutRegistratipnError:error];
        return;
    }
    
    [self.senderDelegate sendMessage:buffer];
}

- (void) receivedBuffer:(NSString *)buffer
{
    NSError *error = nil;
    
    RegistrationResponse *registrationResponse = [self.decoder decodeRegistrationResponseFromBuffer:buffer error:&error];
    
    if (error)
    {
        [self tellDelegateAboutRegistratipnError:error];
    }
    else
    {
        [self.delegate didReceiveRegistration:registrationResponse];
    }
}

- (void) registrateUserWithPhoneNumberFailedWithError:(NSError *)error
{
    [self tellDelegateAboutRegistratipnError:error];
}

- (void) tellDelegateAboutRegistratipnError:(NSError *)error
{
    NSDictionary *errorInfo = nil;
    if (error)
    {
        errorInfo = [NSDictionary dictionaryWithObject: error
                                                forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: RegistrationServiceFailedError
                                                   code: 0
                                               userInfo: errorInfo];
    
    [self.delegate registrateUserWithPhoneNumber:nil failedWithError:reportableError];
}

@end
