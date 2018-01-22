//
//  MockServicesManager.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 22.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicesManager.h"
#import "MessageReceiverType.h"

@interface MockServicesManager : ServicesManager

-(NSArray<id<MessageReceiverType>> *)getServices;

@end
