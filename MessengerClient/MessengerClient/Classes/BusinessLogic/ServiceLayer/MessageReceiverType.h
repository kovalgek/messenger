//
//  ServiceType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 08.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol MessageReceiverType <NSObject>
- (void) receivedBuffer:(NSString *)buffer;
@end

