//
//  MessageCellType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol MessageCellType <NSObject>
- (void) displayTitle:(NSString *)title;
@end
