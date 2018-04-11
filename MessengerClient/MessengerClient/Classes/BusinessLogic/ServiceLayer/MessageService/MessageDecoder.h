//
//  MessageDecoder.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDecoderType.h"

enum {
    MessageDecoderInvalidBufferError,
    MessageDecoderCantParseBuffer,
    MessageDecoderMessageIsEmpty,
};

@interface MessageDecoder : NSObject <MessageDecoderType>

@end
