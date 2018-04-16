//
//  MessageCell.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 14.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellType.h"

@interface MessageCell : UITableViewCell <MessageCellType>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
