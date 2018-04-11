//
//  MessageService.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessageService.h"

static NSString *MessageServiceFailedError = @"MessageServiceFailedError";

@interface MessageService()
@property (nonatomic, strong) id <MessageEncoderType> encoder;
@property (nonatomic, strong) id <MessageDecoderType> decoder;
@end

@implementation MessageService

- (instancetype) initWithEncoder:(id <MessageEncoderType>)encoder
                         decoder:(id <MessageDecoderType>)decoder
{
    self = [super init];
    
    _encoder = encoder;
    _decoder = decoder;
    
    return self;
}

- (void)setDelegate:(id<MessageServiceDelegate>)delegate
{
    if (delegate && ![delegate conformsToProtocol: @protocol(MessageServiceDelegate)])
    {
        [[NSException exceptionWithName: NSInvalidArgumentException
                                 reason: @"Delegate object does not conform to the delegate protocol"
                               userInfo: nil] raise];
    }
    _delegate = delegate;
}

- (void) sendMessageWithMessageRequest:(MessageRequest *)messageRequest
{
    NSError *error = nil;
    NSString *buffer = [self.encoder encodeMessageRequest:messageRequest error:&error];
    
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
    
    MessageResponse *messageResponse = [self.decoder decodeMessageResponseFromBuffer:buffer error:&error];
    
    if (error)
    {
        [self tellDelegateAboutRegistratipnError:error];
        return;
    }
    
    [self.delegate didReceiveMessage:messageResponse];
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
    NSError *reportableError = [NSError errorWithDomain: MessageServiceFailedError
                                                   code: 0
                                               userInfo: errorInfo];
    [self.delegate sendMessage:nil failedWithError:reportableError];
}

@end
