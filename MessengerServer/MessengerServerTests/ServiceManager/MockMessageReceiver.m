//
//  MockMessageReceiver.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 22.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MockMessageReceiver.h"

@implementation MockMessageReceiver

- (void)receivedBuffer:(NSString *)buffer forSocket:(NSInteger)socket
{
    self.buffer = buffer;
}

@end
