//
//  RegistrationInteractor.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationInteractor.h"
#import "RegistrationRequest.h"
#import "RegistrationResponsePlainObject.h"

@interface RegistrationInteractor()
@property (nonatomic, strong) id<RegistrationServiceType> service;
@end

@implementation RegistrationInteractor

- (instancetype)initWithService:(id<RegistrationServiceType>) service
{
    self = [super init];
    _service = service;
    return self;
}

- (void)registerWithPhoneNumber:(NSString *)phoneNumber
{
    RegistrationRequest *registrationRequest = [[RegistrationRequest alloc] initWithPhoneNumber:phoneNumber];
    [self.service registrateUserWithRegistrationRequest:registrationRequest];
}

- (void)didReceiveRegistration:(RegistrationResponse *)registrationResponse
{
    RegistrationResponsePlainObject *registrationResponsePlainObject = [[RegistrationResponsePlainObject alloc] initWithRegistrationResponse:registrationResponse];
    [self.presenter presentRegistrationResponse:registrationResponsePlainObject];
}

- (void)registrateUserWithPhoneNumber:(NSString *)phoneNumber failedWithError:(NSError *)error
{
    [self.presenter presentError:error.localizedDescription];
}

@end
