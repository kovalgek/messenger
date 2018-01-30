//
//  RegistrationService.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationService.h"
#import "RegistrationResponse.h"

static NSString *RegistrationServiceFailedError = @"RegistrationServiceFailedError";

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

- (void) sendRegistrationResponseBackToUser:(RegistrationResponse *)registrationResponse
{
    NSError *error = nil;
    NSString *buffer = [self.encoder encodeRegistrationResponse:registrationResponse error:&error];
    
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
    RegistrationRequest *registrationRequest = [self.decoder decodeRegistrationRequestFromBuffer:buffer error:&error];
    if (error)
    {
        [self tellDelegateAboutRegistratipnError:error];
        return;
    }
    
    // registrationRequest.phoneNumber
    // check if exists
    // if yes -> send error to client
    // if no -> create record in DB and send success status to client
    // in both cases status -(decoder)-> buffer, send back to client
    NSString *status;
    if ([self checkPhoneNumberAndSendSmsToIt])
    {
        status = @"200";
    }
    else
    {
        status = @"400";
    }
    RegistrationResponse *registrationResponse = [[RegistrationResponse alloc] initWithStatus:status];
    [self sendRegistrationResponseBackToUser:registrationResponse];
    [self.delegate didReceiveRequest:registrationRequest];
}

- (BOOL) checkPhoneNumberAndSendSmsToIt
{
    return YES;
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
