//
//  MessagesViewController.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 12.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageCell.h"

@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@end

@implementation MessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.presenter viewCreated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presenter.messagesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MessageCellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier];
    [self.presenter configureMessageCell:cell atIndex:indexPath.row];
    return cell;
}

- (void)updateData
{
    [self.messagesTableView reloadData];
}

- (void)showError:(NSString *)message
{
    NSLog(@"error:%@",message);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.presenter sendMessage:textField.text];
    return NO;
}

@end
