//
//  RegistrationRouter.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationRouter.h"
#import "RegistrationViewController.h"
#import "MessagesRouterInput.h"
#import "RegistrationInteractor.h"
#import "RegistrationPresenter.h"

NSString *registrationStroryboard = @"Registration";
NSString *registrationStroryboardId = @"Registration";

@interface RegistrationRouter()
@property (nonatomic, strong) id<RegistrationServiceType> service;
@property (nonatomic, strong) RegistrationViewController *registrationVC;
@end

@implementation RegistrationRouter

- (instancetype)initWithService:(id<RegistrationServiceType>)service
{
    self = [super init];
    _service = service;
    return self;
}

- (UIViewController *) instantiateViewControllerFromStoryBoard:(NSString *)name
                                      viewControllerIdentifier:(NSString *)viewControllerIdentifier
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
}

- (RegistrationViewController *)registrationViewController
{
    RegistrationViewController *viewController = (RegistrationViewController *)[self instantiateViewControllerFromStoryBoard:registrationStroryboard viewControllerIdentifier:registrationStroryboardId];
    
    RegistrationInteractor *interactor = [[RegistrationInteractor alloc] initWithService:self.service];
    RegistrationPresenter *presenter = [[RegistrationPresenter alloc] initWithRouter:self interactor:interactor];
    presenter.viewController = viewController;
    interactor.presenter = presenter;
    viewController.presenter = presenter;
    self.service.delegate = interactor;

    return viewController;
}

- (void) presentInWindow:(UIWindow *)window
{
    self.registrationVC = [self registrationViewController];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.registrationVC];
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
}

- (void) goToMessagesScreen
{
    [self.messagesRouter presentMessagesScreenWithController:self.registrationVC];
}

@end
