//
//  MessagesViewControllerOutput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol MessagesViewControllerOutput <NSObject>

- (void)updateData;
- (void)showError:(NSString *)message;

@end
