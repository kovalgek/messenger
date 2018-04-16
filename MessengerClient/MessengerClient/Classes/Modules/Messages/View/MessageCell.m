//
//  MessageCell.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)displayTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
