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
    dispatch_async(dispatch_get_main_queue(), ^{
        RegistrationResponsePlainObject *registrationResponsePlainObject = [[RegistrationResponsePlainObject alloc] initWithRegistrationResponse:registrationResponse];
        [self.presenter presentRegistrationResponse:registrationResponsePlainObject];
    });
}

- (void)registrateUserWithPhoneNumber:(NSString *)phoneNumber failedWithError:(NSError *)error
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.presenter presentError:error.localizedDescription];
//    });
}

@end
