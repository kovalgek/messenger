//
//  RegistrationResponseTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RegistrationResponse.h"

@interface RegistrationResponseTests : XCTestCase
{
    RegistrationResponse *registrationResponse;
}
@end

@implementation RegistrationResponseTests

- (void)setUp
{
    [super setUp];
    registrationResponse = [[RegistrationResponse alloc] initWithStatus:@"200"];
}

- (void)tearDown
{
    registrationResponse = nil;
    [super tearDown];
}

- (void)testThatRegistrationResponseExists
{
    XCTAssertNotNil(registrationResponse, @"Should be able to create RegistrationResponse instance");
}

- (void)testThatRegistrationResponseHasAStatus
{
    XCTAssertEqualObjects(registrationResponse.status, @"200", @"RegistrationResponse should has a status attribute");
}

@end
