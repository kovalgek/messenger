//
//  SocketHelperType.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 20.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SocketHelperType <NSObject>

- (int) serverSocketForService:(NSString *)service;
- (int) clientSocketForServerSocket:(int)serverSocket;
- (FILE *)streamForSocket:(int)socket;

@end

