//
//  MessagesViewController.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesViewControllerOutput.h"
#import "MessagesPresenterInput.h"
#import "MessagesPresenterOutput.h"

@interface MessagesViewController : UIViewController <MessagesViewControllerOutput>
@property (nonatomic, strong) id<MessagesPresenterInput, MessagesPresenterOutput> presenter;
@end
