//
//  MockFramer.h
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 22.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FramerType.h"

@interface MockFramer : NSObject <FramerType>

@property (nonatomic, assign) BOOL wasAskedToGetNextMessage;
@property (nonatomic, assign) BOOL wasAskedToPutMessage;

@end
