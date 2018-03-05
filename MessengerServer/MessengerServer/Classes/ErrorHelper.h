//
//  ErrorHelper.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 05.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHelper : NSObject

+ (void) dieWithSystemMessage:(NSString *)message;
+ (void) dieWithUserMessage:(NSString *)message
                     detail:(NSString *)detail;

@end
