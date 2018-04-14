//
//  RegistrationInteractor.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationInteractorInput.h"
#import "RegistrationServiceType.h"
#import "RegistrationPresenterOutput.h"
#import "RegistrationServiceDelegate.h"

@interface RegistrationInteractor : NSObject <RegistrationInteractorInput, RegistrationServiceDelegate>

@property (nonatomic, weak) id<RegistrationPresenterOutput> presenter;

- (instancetype)initWithService:(id<RegistrationServiceType>) service;

@end
