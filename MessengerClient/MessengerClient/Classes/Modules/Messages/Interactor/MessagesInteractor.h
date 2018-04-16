//
//  MessagesInteractor.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageServiceDelegate.h"
#import "MessagesInteractorInput.h"
#import "MessageServiceType.h"
#import "MessagesPresenterOutput.h"

@interface MessagesInteractor : NSObject <MessagesInteractorInput, MessageServiceDelegate>

@property (nonatomic, weak) id<MessagesPresenterOutput> presenter;

- (instancetype)initWithService:(id<MessageServiceType>) service;

@end
