//
//  MessageDecoderType.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@class MessageResponse;

@protocol MessageDecoderType

- (MessageResponse *) decodeMessageResponseFromBuffer:(NSString *)buffer
                                                error:(NSError **)error;

@end

