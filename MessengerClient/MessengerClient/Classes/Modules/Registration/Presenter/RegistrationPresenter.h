//
//  RegistrationPresenter.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationPresenterInput.h"
#import "RegistrationPresenterOutput.h"
#import "RegistrationViewControllerOutput.h"
#import "RegistrationRouterInput.h"
#import "RegistrationInteractorInput.h"

@interface RegistrationPresenter : NSObject <RegistrationPresenterInput, RegistrationPresenterOutput>

@property (nonatomic, weak) id<RegistrationViewControllerOutput> viewController;
@property (nonatomic, weak) id<RegistrationRouterInput> router;
@property (nonatomic, strong) id<RegistrationInteractorInput> interactor;

- (instancetype)initWithRouter:(id<RegistrationRouterInput>)router interactor:(id<RegistrationInteractorInput>) interactor;

@end
