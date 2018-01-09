//
//  MockRegistrationTransportWithError.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationTransportType.h"

@interface MockRegistrationTransportWithError : NSObject <RegistrationTransportType>

@property (nonatomic, strong) NSError *error;

@end
