//
//  RegistrationServiceDelegate.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class RegistrationRequest;

@protocol RegistrationServiceDelegate <NSObject>

- (void) didReceiveError:(NSError *)error;
- (void) didReceiveRequest:(RegistrationRequest *)registrationRequest;

@end
