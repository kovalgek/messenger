//
//  ServicesManager.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "ServicesManager.h"

static const size_t MAX_WIRE_SIZE = 500;

@implementation ServicesManager

- (void) addService:(id<ServiceType>)service
{
    [self.services addObject:service];
}

- (void) removeService:(id<ServiceType>)service
{
    [self.services removeObject:service];
}

- (void) runMessagesLoop
{
    size_t mSize;
    uint8_t inbuf[MAX_WIRE_SIZE];
    
    // Receive and print response
    while ((mSize = [self.framer getNextMesage]) > 0) //ForSocketStream:self.socket inbuf:inbuf maxSize:MAX_WIRE_SIZE)) > 0)
    {
        for(id<ServiceType> service in self.services)
        {
            //[service receiveData:inbuf];
        }
    }
}

@end
