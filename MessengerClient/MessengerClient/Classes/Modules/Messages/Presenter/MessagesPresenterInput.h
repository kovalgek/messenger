//
//  MessagesPresenterInput.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol MessagesPresenterInput <NSObject>

- (void) viewCreated;
- (void) sendMessage:(NSString *)message;

@end
