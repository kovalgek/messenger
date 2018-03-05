//
//  MockFramer.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 22.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MockFramer.h"

@implementation MockFramer

- (int)getNextMesageFromSocketStream:(FILE *)socketStream
                              buffer:(UInt8 *)buffer
                          bufferSize:(size_t)bufferSize
{
    self.wasAskedToGetNextMessage = YES;
    return 0;
}

- (int)putMessageToSocketStream:(FILE *)socketStream
                         buffer:(UInt8 *)buffer
                     bufferSize:(size_t)bufferSize
{
    self.wasAskedToPutMessage = YES;
    return 0;
}

@end
