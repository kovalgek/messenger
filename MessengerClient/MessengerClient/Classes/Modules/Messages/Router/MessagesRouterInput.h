//
//  MessagesRouterInput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol MessagesRouterInput <NSObject>

- (void) presentMessagesScreenWithController:(UIViewController *)controller;

@end
