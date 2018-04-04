//
//  SocketHelperType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 04.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SocketHelperType <NSObject>

- (int) clientSocketForHost:(NSString *)host port:(NSString *)port;
- (FILE *)streamForSocket:(int)socket;

@end
