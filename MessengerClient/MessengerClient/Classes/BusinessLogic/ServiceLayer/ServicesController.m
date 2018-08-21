//
//  ServiceController.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 21.08.2018.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "ServicesController.h"
#import "MessageReceiverType.h"

@interface ServicesController()
@property (nonatomic, strong) NSMutableArray <id<MessageReceiverType>> *services;
@end

@implementation ServicesController

- (instancetype) init
{
    self = [super init];

    _services = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) addService:(id<MessageReceiverType>)service
{
    [self.services addObject:service];
}

- (void) removeService:(id<MessageReceiverType>)service
{
    [self.services removeObject:service];
}

- (void) notifyServicesWithBuffer:(NSString *)receivedBuffer;
{
    for(id<MessageReceiverType> service in self.services)
    {
        [service receivedBuffer:receivedBuffer];
    }
}

@end
