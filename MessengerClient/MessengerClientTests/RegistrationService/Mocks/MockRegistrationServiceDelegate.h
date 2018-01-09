//
//  MockRegistrationServiceDelegate.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationServiceDelegate.h"

@interface MockRegistrationServiceDelegate : NSObject <RegistrationServiceDelegate>

@property (nonatomic, strong) NSError *fetchError;

@end
