//
//  MockSocketManager.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 20.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MockSocketManager.h"

@implementation MockSocketManager

- (int)serverSocketForService:(NSString *)service
{
    return 1;
}

- (int)clientSocketForServerSocket:(int)serverSocket
{
    return 1;
}

- (FILE *)streamForSocket:(int)socket
{
    return nil;
}

@end
