//
//  MessageDecoderType.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class MessageRequest;

@protocol MessageDecoderType

- (MessageRequest *) decodeMessageRequestFromBuffer:(NSString *)buffer
                                              error:(NSError **)error;

@end
