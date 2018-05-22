//
//  MessageService.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessageService.h"
#import "MessageRequest.h"
#import "MessageResponse.h"

static NSString *MessageServiceFailedError = @"MessageServiceFailedError";

@interface MessageService()
@property (nonatomic, strong) id <MessageEncoderType> encoder;
@property (nonatomic, strong) id <MessageDecoderType> decoder;
@property (nonatomic, strong) id <UserStorageType> userStorage;
@end

@implementation MessageService

- (instancetype)initWithEncoder:(id<MessageEncoderType>)encoder
                        decoder:(id<MessageDecoderType>)decoder
                    userStorage:(id<UserStorageType>)userStorage
{
    self = [super init];
    
    _encoder = encoder;
    _decoder = decoder;
    _userStorage = userStorage;
    
    return self;
}

- (void)setServiceDelegate:(id<MessageServiceDelegate>)serviceDelegate
{
    if (serviceDelegate && ![serviceDelegate conformsToProtocol: @protocol(MessageServiceDelegate)])
    {
        [[NSException exceptionWithName: NSInvalidArgumentException
                                 reason: @"Delegate object does not conform to the delegate protocol"
                               userInfo: nil] raise];
    }
    _serviceDelegate = serviceDelegate;
}

- (void)sendMessageResponseBackToUsers:(MessageResponse *)messageResponse
{
    NSError *error = nil;
    NSString *buffer = [self.encoder encodeMessageResponse:messageResponse error:&error];
    
    if (error)
    {
        [self tellDelegateAboutRegistrationError:error];
        return;
    }
    
    [self.senderDelegate sendMessageToAllUsers:buffer];
}

- (void) receivedBuffer:(NSString *)buffer forSocket:(NSInteger)socket
{
    NSError *error = nil;
    MessageRequest *messageRequest = [self.decoder decodeMessageRequestFromBuffer:buffer error:&error];
    
    if (error)
    {
        [self tellDelegateAboutRegistrationError:error];
        return;
    }
    
    [self.serviceDelegate didReceiveMessageRequest:messageRequest];
    
    MessageResponse *messageResponse = [[MessageResponse alloc] initWithMessage:messageRequest.message];
    [self sendMessageResponseBackToUsers:messageResponse];
}

- (void)sendMessageResponseBackToUserFailedWithError:(NSError *)error
{
    [self tellDelegateAboutRegistrationError:error];
}

- (void) tellDelegateAboutRegistrationError:(NSError *)error
{
    NSDictionary *errorInfo = nil;
    if (error)
    {
        errorInfo = [NSDictionary dictionaryWithObject: error
                                                forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: MessageServiceFailedError
                                                   code: 0
                                               userInfo: errorInfo];
    
    [self.serviceDelegate didReceiveError:reportableError];
}

@end
