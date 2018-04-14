//
//  RegistrationRouterInput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol RegistrationRouterInput <NSObject>

/**
 Presents Registration module in window
 
 @param window A window in which module will be presented
 */
- (void) presentInWindow:(UIWindow *)window;
- (void) goToMessagesScreen;

@end

