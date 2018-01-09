//
//  MockRegistrationEncoderWithError.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 30.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationEncoderType.h"

@interface MockRegistrationEncoderWithError : NSObject <RegistrationEncoderType>

@property (nonatomic, strong) NSError *error;

@end
