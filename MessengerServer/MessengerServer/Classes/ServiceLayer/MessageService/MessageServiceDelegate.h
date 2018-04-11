//
//  MessageServiceDelegate.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class MessageRequest;

@protocol MessageServiceDelegate <NSObject>

- (void) didReceiveError:(NSError *)error;
- (void) didReceiveMessageRequest:(MessageRequest *)messageRequest;

@end
