//
//  ServicesManagerTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 22.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MockServicesManager.h"
#import "MockFramer.h"
#import "MessageReceiverType.h"
#import "MockMessageReceiver.h"

@interface ServicesManagerTests : XCTestCase
{
    MockFramer *framer;
    ServicesManager *servicesManager;
    MockServicesManager *mockServicesManager;
    MockMessageReceiver *mockMessageReceiver;
}
@end

@implementation ServicesManagerTests

- (void)setUp
{
    [super setUp];
    framer = [[MockFramer alloc] init];
    mockServicesManager = [[MockServicesManager alloc] initWithFramer:framer];
    servicesManager = [[ServicesManager alloc] initWithFramer:framer];
    mockMessageReceiver = [[MockMessageReceiver alloc] init];
}

- (void)tearDown
{
    servicesManager = nil;
    mockServicesManager = nil;
    framer = nil;
    mockMessageReceiver = nil;
    [super tearDown];
}

- (void) testThatServicesManagerExists
{
    XCTAssertNotNil(servicesManager, @"Should be able to create ServicesManager instance");
}

- (void) testThatServiceCanBeAdded
{
    [mockServicesManager addService:mockMessageReceiver];
    NSArray<id<MessageReceiverType>> *messageReceiveres = [mockServicesManager getServices];
    XCTAssertEqualObjects(messageReceiveres.firstObject, mockMessageReceiver, @"Objects should be equal");
}

- (void) testThatServiceCanBeDeleted
{
    [mockServicesManager addService:mockMessageReceiver];
    [mockServicesManager removeService:mockMessageReceiver];
    NSArray<id<MessageReceiverType>> *messageReceiveres = [mockServicesManager getServices];
    XCTAssertEqual(messageReceiveres.count, 0, @"The array should be empty");
}

- (void) testThatServiceCallsFramersGetNextMessage
{
    [servicesManager runMessagesLoop];
    XCTAssert(framer.wasAskedToGetNextMessage, @"Get next message was called");
}

- (void) testThatServiceCallsFramersPutMessage
{
    [servicesManager sendMessage:@"something"];
    XCTAssert(framer.wasAskedToPutMessage, @"Put message was called");
}

@end
