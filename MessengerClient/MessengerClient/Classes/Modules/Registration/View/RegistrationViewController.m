//
//  RegistrationViewController.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@end

@implementation RegistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.presenter viewCreated];
}

- (IBAction)registrationButtonPressed:(id)sender
{
    [self.presenter registerUserWithPhoneNumber:self.phoneNumberTextField.text];
}

- (void)showError:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAlertAction = [UIAlertAction actionWithTitle:@"ok"
                                                             style:UIAlertActionStyleDefault
                                                           handler:nil];
    [alertController addAction:yesAlertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
