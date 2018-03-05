//
//  ErrorHelper.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 05.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "ErrorHelper.h"

@implementation ErrorHelper

+ (void) dieWithUserMessage:(NSString *)message
                     detail:(NSString *)detail
{
    NSLog(@"%@: %@\n",message, detail);
    exit(1);
}

+ (void) dieWithSystemMessage:(NSString *)message
{
    perror([message UTF8String]);
    exit(1);
}

@end
