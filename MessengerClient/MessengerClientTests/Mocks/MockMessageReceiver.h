//
//  MockMessageReceiver.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 22.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageReceiverType.h"

@interface MockMessageReceiver : NSObject <MessageReceiverType>

@property (nonatomic, copy) NSString *buffer;

@end
