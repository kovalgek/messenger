//
//  RegistrationDecoder.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationDecoderType.h"

enum {
    RegistrationDecoderInvalidBufferError,
    RegistrationDecoderCantParseBuffer,
    RegistrationDecoderStatusIsEmpty,
};

@interface RegistrationDecoder : NSObject <RegistrationDecoderType>

@end
