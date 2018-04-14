//
//  RegistrationViewControllerOutput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol RegistrationViewControllerOutput <NSObject>

- (void)showError:(NSString *)message;

@end
