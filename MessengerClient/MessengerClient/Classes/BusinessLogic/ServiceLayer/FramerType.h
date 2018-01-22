//
//  FramerType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 08.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#include <stdio.h>

@protocol FramerType

- (int) getNextMesageFromSocketStream:(FILE *)socketStream
                               buffer:(UInt8 *)buffer
                           bufferSize:(size_t)bufferSize;

- (int) putMessageToSocketStream:(FILE *)socketStream
                          buffer:(UInt8 *)buffer
                      bufferSize:(size_t)bufferSize;

@end
