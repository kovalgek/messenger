//
//  UserTests.m
//  MessengerServerTests
//
//  Created by Anton Kovalchuk on 05.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"

@interface UserTests : XCTestCase
{
    User *user;
}
@end

@implementation UserTests

- (void)setUp
{
    [super setUp];
    user = [[User alloc] initWithPhoneNumber:@"+31621309308"];
}

- (void)tearDown
    {
    user = nil;
    [super tearDown];
}

- (void)testThatUserExists
{
    XCTAssertNotNil(user, @"Should be able to create User instance");
}

- (void)testThatUserHasPhoneNumber
{
    XCTAssertEqualObjects(user.phoneNumber, @"+31621309308", @"User should has a phone number");
}

@end
