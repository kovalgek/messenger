//
//  ViewController.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import "ViewController.h"
#import "ServicesManager.h"
#import "DelimiterFramer.h"
#import "RegistrationService.h"
#import "RegistrationDecoder.h"
#import "RegistrationEncoder.h"
#import "RegistrationRequest.h"
#import "SocketHelper.h"
#import "RegistrationServiceType.h"

@interface ViewController ()
@property (nonatomic, strong) ServicesManager *servicesManager;
@property (nonatomic, strong) RegistrationService *registrationService;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RegistrationDecoder *decoder = [[RegistrationDecoder alloc] init];
    RegistrationEncoder *encoder = [[RegistrationEncoder alloc] init];
    self.registrationService = [[RegistrationService alloc] initWithEncoder:encoder decoder:decoder];
    DelimiterFramer *delimiterFramer = [[DelimiterFramer alloc] init];
    SocketHelper *socketHelper = [[SocketHelper alloc] init];
    self.servicesManager = [[ServicesManager alloc] initWithFramer:delimiterFramer socketHelper:socketHelper];;
    [self.servicesManager setupTCPClientSocketWithHost:@"127.0.0.1" port:@"5000"];
    [self.servicesManager addService:self.registrationService];
    self.registrationService.senderDelegate = self.servicesManager;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.servicesManager runMessagesLoop];
    });
}

- (IBAction)registrateButtonPressed:(id)sender
{
    RegistrationRequest *registrationRequest = [[RegistrationRequest alloc] initWithPhoneNumber:@"123"];
    [self.registrationService registrateUserWithRegistrationRequest:registrationRequest];
}

@end
