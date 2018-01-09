//
//  MockRegistrationTransport.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationTransportType.h"

@interface MockRegistrationTransport : NSObject <RegistrationTransportType>

@property (nonatomic) BOOL wasAskedToRegisterUser;

@end
