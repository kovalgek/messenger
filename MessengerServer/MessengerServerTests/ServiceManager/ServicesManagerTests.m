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
#import "SocketHelperType.h"
#import "MessageReceiverType.h"
#import "MockMessageReceiver.h"
#import "FramerType.h"
#import "MockFramer.h"

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

- (void) testThatSetupAsksForServerSocket
{
    NSString *service = @"testService";
    [self.servicesManager setupTCPServerSocketWithService:service];
    OCMVerify([self.socketHelper serverSocketForService:service]);
}

- (void) testThatRunLoopCallsClientSocket
{
     OCMStub([self.socketHelper serverSocketForService:@"127.0.0.1"]).andReturn(10);
     [self.servicesManager setupTCPServerSocketWithService:@"127.0.0.1"];
     [self.servicesManager stopMessagesLoop];
     [self.servicesManager runMessagesLoop];
     OCMVerify([self.socketHelper clientSocketForServerSocket:10]);
}

- (void) testThatRunLoopHandlesClientsAndParsesSocketBuffer
{
    MockFramer *mockFramer = [[MockFramer alloc] init];
    self.servicesManager = [[ServicesManager alloc] initWithFramer:mockFramer socketHelper:self.socketHelper];
    
    OCMStub([self.socketHelper serverSocketForService:@"127.0.0.1"]).andReturn(10);
    OCMStub([self.socketHelper clientSocketForServerSocket:10]).andReturn(20);
    [self.servicesManager setupTCPServerSocketWithService:@"127.0.0.1"];
    [self.servicesManager stopMessagesLoop];
    [self.servicesManager runMessagesLoop];
    
    XCTAssertTrue([self waitFor: ^{ return mockFramer.wasAskedToGetNextMessage; }], @"dispatch_async never ran its code");
}

- (void) testThatRunLoopCallsHandlesClientAndSendsReceivedBufferToServiceReseiver
{
    MockMessageReceiver *mockMessageReceiver = [[MockMessageReceiver alloc] init];
    MockFramer *mockFramer = [[MockFramer alloc] init];
    self.servicesManager = [[ServicesManager alloc] initWithFramer:mockFramer socketHelper:self.socketHelper];
    [self.servicesManager addService:mockMessageReceiver];
    
    OCMStub([self.socketHelper serverSocketForService:@"127.0.0.1"]).andReturn(10);
    OCMStub([self.socketHelper clientSocketForServerSocket:10]).andReturn(20);
    
    [self.servicesManager setupTCPServerSocketWithService:@"127.0.0.1"];
    [self.servicesManager stopMessagesLoop];
    [self.servicesManager runMessagesLoop];
    
    XCTAssertTrue([self waitFor: ^{ return (BOOL)(mockMessageReceiver.buffer.length > 0); }], @"dispatch_async never ran its code");
}

- (void) testThatSendMessageCallsPutMesage
{
    [self.servicesManager sendMessage:@"test" toSocket:1];
    OCMVerify([self.framer putMessageToSocketStream:[OCMArg anyPointer] buffer:[OCMArg anyPointer] bufferSize:4]);
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
