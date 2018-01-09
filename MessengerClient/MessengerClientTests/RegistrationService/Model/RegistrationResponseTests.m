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
    NSError *error;
}
@end

@implementation RegistrationResponseTests

- (void)setUp
{
    [super setUp];
    error = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    registrationResponse = [[RegistrationResponse alloc] initWithError:error];
}

- (void)tearDown
{
    registrationResponse = nil;
    error = nil;
    [super tearDown];
}

- (void)testThatRegistrationResponseExists
{
    XCTAssertNotNil(registrationResponse, @"Should be able to create RegistrationResponse instance");
}

- (void)testThatRegistrationResponseHasError
{
    XCTAssertEqualObjects(registrationResponse.error, error, @"RegistrationResponse should has an error attribute");
}

@end
