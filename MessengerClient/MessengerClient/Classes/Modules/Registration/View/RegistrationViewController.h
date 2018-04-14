//
//  RegistrationViewController.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationViewControllerOutput.h"
#import "RegistrationPresenterOutput.h"
#import "RegistrationPresenterInput.h"

@interface RegistrationViewController : UIViewController <RegistrationViewControllerOutput>
@property (strong, nonatomic) id<RegistrationPresenterInput, RegistrationPresenterOutput> presenter;
@end
