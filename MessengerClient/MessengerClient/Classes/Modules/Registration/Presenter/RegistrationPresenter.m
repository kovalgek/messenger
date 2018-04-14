//
//  RegistrationPresenter.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationPresenter.h"

@implementation RegistrationPresenter

- (instancetype)initWithRouter:(id<RegistrationRouterInput>)router
                    interactor:(id<RegistrationInteractorInput>)interactor
{
    self = [super init];
    _router = router;
    _interactor = interactor;
    return self;
}

- (void)viewCreated
{
    
}

- (void)registerUserWithPhoneNumber:(NSString *)phoneNumber
{
    [self.interactor registerWithPhoneNumber:phoneNumber];
}

- (void)presentRegistrationResponse:(RegistrationResponsePlainObject *)registrationResponse
{
    if ([registrationResponse.status isEqualToString:@"200"])
    {
        [self.router goToMessagesScreen];
    }
    else
    {
        [self.viewController showError:@"Some error"];
    }
}

- (void)presentError:(NSString *)message
{
    [self.viewController showError:message];
}

@end
