//
//  AddressUtility.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 01.02.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressUtility : NSObject

+ (void) printSocketAddress:(const struct sockaddr *)address
                     stream:(FILE *)stream;

@end
