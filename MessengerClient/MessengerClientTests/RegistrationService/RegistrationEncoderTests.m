//
//  RegistrationEncoderTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 09.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RegistrationRequest.h"
#import "RegistrationEncoder.h"

@interface RegistrationEncoderTests : XCTestCase
{
    RegistrationEncoder *encoder;
}
@end

@implementation RegistrationEncoderTests

- (void)setUp
{
    [super setUp];
    encoder = [[RegistrationEncoder alloc] init];
}

- (void)tearDown
{
    encoder = nil;
    [super tearDown];
}

- (void) testThatNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([encoder encodeRegistrationRequest:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    RegistrationRequest *registrationRequest = [[RegistrationRequest alloc] initWithPhoneNumber:@"something"];
    XCTAssertNoThrow([encoder encodeRegistrationRequest:registrationRequest error:NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testEncoderEncodeInputAsExcpected
{
    NSError *error;
    RegistrationRequest *registrationRequest = [[RegistrationRequest alloc] initWithPhoneNumber:@"anton"];
    NSString *result = [encoder encodeRegistrationRequest:registrationRequest error:&error];
    XCTAssertEqualObjects(result, @"registration anton", @"Encoder should create string with magic word and info separated by delimiter");
}

@end
