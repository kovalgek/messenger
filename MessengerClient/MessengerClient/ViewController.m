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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RegistrationDecoder *decoder = [[RegistrationDecoder alloc] init];
    RegistrationEncoder *encoder = [[RegistrationEncoder alloc] init];
    RegistrationService *registrationService = [[RegistrationService alloc] initWithEncoder:encoder decoder:decoder];
    DelimiterFramer *delimiterFramer = [[DelimiterFramer alloc] init];
    ServicesManager *servicesManager = [[ServicesManager alloc] initWithFramer:delimiterFramer];
    [servicesManager setupTCPClientSocketWithHost:@"127.0.0.1" port:@"5000"];
    [servicesManager addService:registrationService];
    registrationService.senderDelegate = servicesManager;
    
    
    RegistrationRequest *registrationRequest = [[RegistrationRequest alloc] initWithPhoneNumber:@"123"];
    [registrationService registrateUserWithRegistrationRequest:registrationRequest];
    NSLog(@"run");
    
    [servicesManager runMessagesLoop];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
