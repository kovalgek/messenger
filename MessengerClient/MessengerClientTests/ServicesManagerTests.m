//
//  ServicesManagerTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 22.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MockFramer.h"
#import "MessageReceiverType.h"
#import "MockMessageReceiver.h"
#import "ServicesManager.h"

@interface ServicesManagerTests : XCTestCase
@property (nonatomic, strong) ServicesManager *servicesManager;
@property (nonatomic, strong) id<SocketHelperType> socketHelper;
@property (nonatomic, strong) id<MessageReceiverType> messageReceiver;
@property (nonatomic, strong) id<FramerType> framer;
@end

@implementation ServicesManagerTests

- (void)setUp
{
    [super setUp];
    self.framer = OCMProtocolMock(@protocol(FramerType));
    self.socketHelper = OCMProtocolMock(@protocol(SocketHelperType));
    self.servicesManager = [[ServicesManager alloc] initWithFramer:self.framer socketHelper:self.socketHelper];
}

- (void)tearDown
{
    self.framer = nil;
    self.socketHelper = nil;
    self.servicesManager = nil;
    [super tearDown];
}

- (void) testThatServicesManagerExists
{
    XCTAssertNotNil(self.servicesManager, @"Should be able to create ServicesManager instance");
}

- (void) testThatSetupAsksForClientSocket
{
    [self.servicesManager setupTCPClientSocketWithHost:@"127.0.0.1" port:@"5000"];
    OCMVerify([self.socketHelper clientSocketForHost:@"127.0.0.1" port:@"5000"]);
}

- (void) testThatRunLoopParsesSocketBuffer
{
    MockFramer *mockFramer = [[MockFramer alloc] init];
    self.servicesManager = [[ServicesManager alloc] initWithFramer:mockFramer socketHelper:self.socketHelper];
    [self.servicesManager runMessagesLoop];
    XCTAssertTrue([self waitFor: ^{ return mockFramer.wasAskedToGetNextMessage; }], @"Framer should be asked");
}

- (void) testThatRunLoopSendsReceivedBufferToServiceReseiver
{
    MockMessageReceiver *mockMessageReceiver = [[MockMessageReceiver alloc] init];
    MockFramer *mockFramer = [[MockFramer alloc] init];
    self.servicesManager = [[ServicesManager alloc] initWithFramer:mockFramer socketHelper:self.socketHelper];
    [self.servicesManager addService:mockMessageReceiver];
    [self.servicesManager runMessagesLoop];
    
    XCTAssertTrue([self waitFor: ^{ return (BOOL)(mockMessageReceiver.buffer.length > 0); }], @"Buffer should be passed to service");
}

- (void) testThatSendMessageCallsPutMesage
{
    [self.servicesManager sendMessage:@"IDDQD"];
    OCMVerify([self.framer putMessageToSocketStream:[OCMArg anyPointer] buffer:[OCMArg anyPointer] bufferSize:5]);
}

#pragma mark - helpers

- (BOOL) waitFor:(BOOL (^)(void))block
{
    NSTimeInterval start = [[NSProcessInfo processInfo] systemUptime];
    while(!block() && [[NSProcessInfo processInfo] systemUptime] - start <= 10)
        ; // do nothing
    return block();
}

@end
