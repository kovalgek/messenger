//
//  MessagesPresenter.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessagesPresenter.h"
#import "MessageResponsePlainObject.h"
#import "MessagesViewControllerOutput.h"
#import "MessageCellType.h"

@interface MessagesPresenter()
@property (nonatomic, strong) NSMutableArray <MessageResponsePlainObject *> *messages;
@end

@implementation MessagesPresenter

- (instancetype)initWithRouter:(id<MessagesRouterInput>)router interactor:(id<MessagesInteractorInput>)interactor
{
    self = [super  init];
    _router = router;
    _interactor = interactor;
    _messages = [[NSMutableArray alloc] init];
    return self;
}

- (void)viewCreated
{
    
}

- (void)sendMessage:(NSString *)message
{
    [self.interactor sendMessage:message];
}

- (void)presentMessageResponse:(MessageResponsePlainObject *)messageResponse
{
    [self.messages addObject:messageResponse];
    [self.viewController updateData];
}

- (void)presentError:(NSString *)message
{
    [self.viewController showError:message];
}

- (void)configureMessageCell:(id<MessageCellType>)view atIndex:(NSUInteger)index
{
    MessageResponsePlainObject *messageResponse = [self.messages objectAtIndex:index];
    [view displayTitle:messageResponse.message];
}

- (NSUInteger)messagesCount
{
    return self.messages.count;
}

@end
