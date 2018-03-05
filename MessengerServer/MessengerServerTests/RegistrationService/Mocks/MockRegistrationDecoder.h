//
//  MockRegistrationDecoder.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationDecoderType.h"

@interface MockRegistrationDecoder : NSObject <RegistrationDecoderType>

@property (nonatomic, copy) NSString *buffer;
@property (nonatomic, copy) NSError *errorToSet;
@property (nonatomic, strong) RegistrationRequest *dataToReturn;

@end
