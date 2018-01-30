//
//  RegistrationRequestTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RegistrationRequest.h"

@interface RegistrationRequestTests : XCTestCase
{
    RegistrationRequest *registrationRequest;
}
@end

@implementation RegistrationRequestTests

- (void)setUp
{
    [super setUp];
    registrationRequest = [[RegistrationRequest alloc] initWithPhoneNumber:@"+31621309309"];
}

- (void)tearDown
{
    registrationRequest = nil;
    [super tearDown];
}

- (void)testThatRegistrationRequestExists
{
    XCTAssertNotNil(registrationRequest, @"Should be able to create RegistrationRequest instance");
}

- (void)testThatRegistrationRequestHasPhoneNumber
{
    XCTAssertEqualObjects(registrationRequest.phoneNumber, @"+31621309309", @"RegistrationRequest should has an phoneNumber attribute");
}

@end
