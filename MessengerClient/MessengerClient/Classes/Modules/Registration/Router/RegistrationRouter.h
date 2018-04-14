//
//  RegistrationRouter.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationRouterInput.h"
#import "MessagesRouterInput.h"
#import "RegistrationServiceType.h"

@interface RegistrationRouter : NSObject <RegistrationRouterInput>

- (instancetype)initWithService:(id<RegistrationServiceType>) service;

@property (nonatomic, strong) id<MessagesRouterInput> messagesRouter;

@end
