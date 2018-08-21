//
//  MessagesInteractor.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessagesInteractor.h"
#import "MessageServiceType.h"
#import "MessageRequest.h"
#import "MessageResponsePlainObject.h"

@interface MessagesInteractor()
@property (nonatomic, strong) id<MessageServiceType> service;
@end

@implementation MessagesInteractor

- (instancetype)initWithService:(id<MessageServiceType>)service
{
    self = [super init];
    
    _service = service;
    
    return self;
}

- (void)sendMessage:(NSString *)message
{
    MessageRequest *messageRequest = [[MessageRequest alloc] initWithMessage:message];
    [self.service sendMessageWithMessageRequest:messageRequest];
}

- (void)sendMessage:(NSString *)message failedWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.presenter presentError:error.description];
    });
}

-(void)didReceiveMessage:(MessageResponse *)messageResponse
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MessageResponsePlainObject *messageResponsePlainObject = [[MessageResponsePlainObject alloc] initWithMessageResponse:messageResponse];
        [self.presenter presentMessageResponse:messageResponsePlainObject];
    });
}

@end
