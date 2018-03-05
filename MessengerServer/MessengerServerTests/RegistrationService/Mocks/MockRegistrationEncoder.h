//
//  MockRegistrationEncoder.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationEncoderType.h"

@interface MockRegistrationEncoder : NSObject <RegistrationEncoderType>

@property (nonatomic, copy) NSString *status;

@end
