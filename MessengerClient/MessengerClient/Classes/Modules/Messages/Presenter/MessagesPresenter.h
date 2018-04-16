//
//  MessagesPresenter.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagesViewControllerOutput.h"
#import "MessagesRouterInput.h"
#import "MessagesInteractorInput.h"
#import "MessagesPresenterInput.h"
#import "MessagesPresenterOutput.h"

@interface MessagesPresenter : NSObject <MessagesPresenterInput, MessagesPresenterOutput>

@property (nonatomic, weak) id<MessagesViewControllerOutput> viewController;
@property (nonatomic, weak) id<MessagesRouterInput> router;
@property (nonatomic, strong) id<MessagesInteractorInput> interactor;

- (instancetype)initWithRouter:(id<MessagesRouterInput>)router interactor:(id<MessagesInteractorInput>) interactor;

@end
