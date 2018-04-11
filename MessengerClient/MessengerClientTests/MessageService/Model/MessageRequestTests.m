//
//  MessageRequestTests.m
//  MessengerServerTests
//
//  Created by Anton Kovalchuk on 10.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MessageRequest.h"

@interface MessageRequestTests : XCTestCase
@property (nonatomic, strong) MessageRequest *messageRequest;
@end

@implementation MessageRequestTests

- (void)setUp
{
    [super setUp];
    self.messageRequest = [[MessageRequest alloc] initWithMessage:@"Hi all"];
}

- (void)tearDown
{
    self.messageRequest = nil;
    [super tearDown];
}

- (void)testThatMessageRequestExists
{
    XCTAssertNotNil(self.messageRequest, @"Should be able to create MessageRequest instance");
}

- (void)testThatMessageRequestHasMessage
{
    XCTAssertEqualObjects(self.messageRequest.message, @"Hi all", @"MessageRequest should has a message attribute");
}

@end
