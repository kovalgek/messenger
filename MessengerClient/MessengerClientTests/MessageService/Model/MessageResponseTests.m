//
//  MessageResponseTests.m
//  MessengerServerTests
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MessageResponse.h"

@interface MessageResponseTests : XCTestCase
@property (nonatomic, strong) MessageResponse *messageResponse;
@end

@implementation MessageResponseTests

- (void)setUp
{
    [super setUp];
    self.messageResponse = [[MessageResponse alloc] initWithMessage:@"Hi all"];
}

- (void)tearDown
{
    self.messageResponse = nil;
    [super tearDown];
}

- (void)testThatMessageRequestExists
{
    XCTAssertNotNil(self.messageResponse, @"Should be able to create MessageResponse instance");
}

- (void)testThatMessageRequestHasMessage
{
    XCTAssertEqualObjects(self.messageResponse.message, @"Hi all", @"MessageResponse should has a message attribute");
}

@end
