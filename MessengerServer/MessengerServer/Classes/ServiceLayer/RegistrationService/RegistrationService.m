//
//  RegistrationService.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationService.h"
#import "RegistrationResponse.h"
#import "UserStorage.h"
#import "RegistrationRequest.h"
#import "User.h"

static NSString *RegistrationServiceFailedError = @"RegistrationServiceFailedError";

@interface RegistrationService()
@property (nonatomic, strong) id <RegistrationEncoderType> encoder;
@property (nonatomic, strong) id <RegistrationDecoderType> decoder;
@property (nonatomic, strong) UserStorage *userStorage;
@end

@implementation RegistrationService

- (instancetype) initWithEncoder:(id <RegistrationEncoderType>)encoder
                         decoder:(id <RegistrationDecoderType>)decoder
{
    self = [super init];
    
    _encoder = encoder;
    _decoder = decoder;
    
    _userStorage = [[UserStorage alloc] init];
    
    return self;
}

- (void)setServiceDelegate:(id<RegistrationServiceDelegate>)serviceDelegate
{
    if (serviceDelegate && ![serviceDelegate conformsToProtocol: @protocol(RegistrationServiceDelegate)])
    {
        [[NSException exceptionWithName: NSInvalidArgumentException
                                 reason: @"Delegate object does not conform to the delegate protocol"
                               userInfo: nil] raise];
    }
    _serviceDelegate = serviceDelegate;
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

- (void) receivedBuffer:(NSString *)buffer forSocket:(NSInteger)socket
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
    if ([self checkPhoneNumber:registrationRequest.phoneNumber forSocket:socket])
    {
        status = @"200";
    }
    else
    {
        status = @"400";
    }
    RegistrationResponse *registrationResponse = [[RegistrationResponse alloc] initWithStatus:status];
    [self sendRegistrationResponseBackToUser:registrationResponse];
    [self.serviceDelegate didReceiveRequest:registrationRequest];
}

- (BOOL) checkPhoneNumber:(NSString *)phoneNumber forSocket:(NSInteger)socket
{
    if ([self.userStorage findUserWithPhoneNumber:phoneNumber])
    {
        return NO;
    }
    User *user = [[User alloc] initWithPhoneNumber:phoneNumber];
    user.socket = socket;
    [self.userStorage addUser:user];
    
    NSArray *temp = [self.userStorage allUsers];
    NSLog(@"temp=%@",[temp description]);
    return YES;
}

- (void) sendRegistrationResponseBackToUserFailedWithError:(NSError *)error
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
    
    [self.serviceDelegate didReceiveError:reportableError];
}

@end
