//
//  ServicesManagerTests.m
//  MessengerServerTests
//
//  Created by Anton Kovalchuk on 23.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "ServicesManager.h"
#import "MessageReceiverType.h"
#import "SocketManagerType.h"
#import "MessageReceiverType.h"
#import "FramerType.h"
#import "MockFramer.h"
#import "MockMessageReceiver.h"

@interface ServicesManagerTests : XCTestCase
@property (nonatomic, strong) ServicesManager *servicesManager;
@property (nonatomic, strong) id<SocketManagerType> socketManager;
@property (nonatomic, strong) id<MessageReceiverType> messageReceiver;
@property (nonatomic, strong) id<FramerType> framer;
@end

@implementation ServicesManagerTests

- (void)setUp
{
    [super setUp];
    self.framer = OCMProtocolMock(@protocol(FramerType));
    self.socketManager = OCMProtocolMock(@protocol(SocketManagerType));
    self.servicesManager = [[ServicesManager alloc] initWithFramer:self.framer socketManager:self.socketManager];
}

- (void)tearDown
{
    self.framer = nil;
    self.socketManager = nil;
    self.servicesManager = nil;
    [super tearDown];
}

- (void) testThatServicesManagerExists
{
    XCTAssertNotNil(self.servicesManager, @"Should be able to create ServicesManager instance");
}

- (void) testThatSetupCallsSocket
{
    NSString *service = @"testService";
    [self.servicesManager setupTCPServerSocketWithService:service];
    OCMVerify([self.socketManager serverSocketForService:service]);
}

- (void) testThatRunLoopCallsClientSocket
{
     OCMStub([self.socketManager serverSocketForService:@"127.0.0.1"]).andReturn(10);
     [self.servicesManager setupTCPServerSocketWithService:@"127.0.0.1"];
     [self.servicesManager runMessagesLoop];
     OCMVerify([self.socketManager clientSocketForServerSocket:10]);
}

- (void) testThatRunLoopCallsGetNextMesageFromSocketStream
{
    MockFramer *mockFramer = [[MockFramer alloc] init];
    self.servicesManager = [[ServicesManager alloc] initWithFramer:mockFramer socketManager:self.socketManager];
    
    OCMStub([self.socketManager serverSocketForService:@"127.0.0.1"]).andReturn(10);
    OCMStub([self.socketManager clientSocketForServerSocket:10]).andReturn(20);
    [self.servicesManager setupTCPServerSocketWithService:@"127.0.0.1"];
    [self.servicesManager runMessagesLoop];
    [self.servicesManager stopMessagesLoop];
    
    XCTAssertTrue([self waitFor: ^{ return mockFramer.wasAskedToGetNextMessage; }], @"dispatch_async never ran its code");
}

- (void) testThatRunLoopCallsServiceReceiver
{
    MockMessageReceiver *mockMessageReceiver = [[MockMessageReceiver alloc] init];
    MockFramer *mockFramer = [[MockFramer alloc] init];
    self.servicesManager = [[ServicesManager alloc] initWithFramer:mockFramer socketManager:self.socketManager];
    [self.servicesManager addService:mockMessageReceiver];
    
    OCMStub([self.socketManager serverSocketForService:@"127.0.0.1"]).andReturn(10);
    OCMStub([self.socketManager clientSocketForServerSocket:10]).andReturn(20);
    
    [self.servicesManager setupTCPServerSocketWithService:@"127.0.0.1"];
    [self.servicesManager runMessagesLoop];
    [self.servicesManager stopMessagesLoop];
    
    XCTAssertTrue([self waitFor: ^{ return (BOOL)(mockMessageReceiver.buffer.length > 0); }], @"dispatch_async never ran its code");
}

- (void) testThatSendMessageCallsPutMesage
{
    [self.servicesManager sendMessage:@"test" toSocket:1];
    OCMVerify([self.framer putMessageToSocketStream:[OCMArg anyPointer] buffer:[OCMArg anyPointer] bufferSize:4096]);
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
