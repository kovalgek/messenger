//
//  MessagesRouter.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessagesRouter.h"
#import "MessageServiceType.h"
#import "MessagesViewController.h"
#import "MessagesInteractor.h"
#import "MessagesPresenter.h"

NSString *messagesStroryboard = @"Messages";
NSString *messagesStroryboardId = @"Messages";

@interface MessagesRouter()
@property (nonatomic, strong) id<MessageServiceType> service;
@property (nonatomic, strong) MessagesViewController *messagesVC;
@end

@implementation MessagesRouter

- (instancetype)initWithService:(id<MessageServiceType>)service
{
    self = [super init];
    _service = service;
    return self;
}

- (void)presentMessagesScreenWithController:(UIViewController *)controller
{
    self.messagesVC = [self messagesViewController];
    [controller.navigationController pushViewController:self.messagesVC animated:YES];
}

- (UIViewController *) instantiateViewControllerFromStoryBoard:(NSString *)name
                                      viewControllerIdentifier:(NSString *)viewControllerIdentifier
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
}

- (MessagesViewController *)messagesViewController
{
    MessagesViewController *viewController = (MessagesViewController *)[self instantiateViewControllerFromStoryBoard:messagesStroryboard viewControllerIdentifier:messagesStroryboardId];
    
    MessagesInteractor *interactor = [[MessagesInteractor alloc] initWithService:self.service];
    MessagesPresenter *presenter = [[MessagesPresenter alloc] initWithRouter:self interactor:interactor];
    presenter.viewController = viewController;
    interactor.presenter = presenter;
    viewController.presenter = presenter;
    self.service.delegate = interactor;
    
    return viewController;
}

@end
