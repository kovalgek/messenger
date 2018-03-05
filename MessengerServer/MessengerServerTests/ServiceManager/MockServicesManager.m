//
//  MockServicesManager.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 22.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MockServicesManager.h"

@implementation MockServicesManager

-(NSArray<id<MessageReceiverType>> *)getServices
{
    return [services copy];
}

@end
