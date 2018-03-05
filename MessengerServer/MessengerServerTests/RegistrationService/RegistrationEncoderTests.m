//
//  RegistrationEncoderTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 09.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RegistrationResponse.h"
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
    XCTAssertThrows([encoder encodeRegistrationResponse:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    RegistrationResponse *registrationResponse = [[RegistrationResponse alloc] initWithStatus:@"200"];
    XCTAssertNoThrow([encoder encodeRegistrationResponse:registrationResponse error:NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testEncoderEncodeInputAsExcpected
{
    NSError *error;
    RegistrationResponse *registrationResponse = [[RegistrationResponse alloc] initWithStatus:@"200"];
    NSString *result = [encoder encodeRegistrationResponse:registrationResponse error:&error];
    XCTAssertEqualObjects(result, @"registration 200", @"Encoder should create string with magic word and info separated by delimiter");
}

@end
