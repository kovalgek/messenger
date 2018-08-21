//
//  SocketControllerTests.m
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
#import "SocketController.h"
#import "ServicesControllerType.h"
#import "ServicesController.h"

@interface SocketControllerTests : XCTestCase
@property (nonatomic, strong) SocketController *socketController;
@property (nonatomic, strong) id<SocketHelperType> socketHelper;
@property (nonatomic, strong) id<MessageReceiverType> messageReceiver;
@property (nonatomic, strong) id<ServicesControllerType> serviceController;
@property (nonatomic, strong) id<FramerType> framer;
@end

@implementation SocketControllerTests

- (void)setUp
{
    [super setUp];
    self.framer = OCMProtocolMock(@protocol(FramerType));
    self.socketHelper = OCMProtocolMock(@protocol(SocketHelperType));
    self.serviceController = OCMProtocolMock(@protocol(ServicesControllerType));
    self.socketController = [[SocketController alloc] initWithFramer:self.framer
                                                        socketHelper:self.socketHelper
                                                   serviceController:self.serviceController];
}

- (void)tearDown
{
    self.framer = nil;
    self.socketHelper = nil;
    self.socketController = nil;
    self.serviceController = nil;
    [super tearDown];
}

- (void) testThatSocketControllerExists
{
    XCTAssertNotNil(self.socketController, @"Should be able to create SocketController instance");
}

- (void) testThatSetupAsksForClientSocket
{
    [self.socketController setupTCPClientSocketWithHost:@"127.0.0.1" port:@"5000"];
    OCMVerify([self.socketHelper clientSocketForHost:@"127.0.0.1" port:@"5000"]);
}

- (void) testThatRunLoopParsesSocketBuffer
{
    MockFramer *mockFramer = [[MockFramer alloc] init];
    self.socketController = [[SocketController alloc] initWithFramer:mockFramer
                                                        socketHelper:self.socketHelper
                                                   serviceController:self.serviceController];
    [self.socketController runMessagesLoop];
    XCTAssertTrue([self waitFor: ^{ return mockFramer.wasAskedToGetNextMessage; }], @"Framer should be asked");
}

//- (void) testThatRunLoopSendsReceivedBufferToServiceReseiver
//{
//    MockMessageReceiver *mockMessageReceiver = [[MockMessageReceiver alloc] init];
//    MockFramer *mockFramer = [[MockFramer alloc] init];
//    self.socketController = [[SocketController alloc] initWithFramer:mockFramer socketHelper:self.socketHelper serviceController:self.serviceController];
//    [self.socketController addService:mockMessageReceiver];
//    [self.socketController runMessagesLoop];
//
//    XCTAssertTrue([self waitFor: ^{ return (BOOL)(mockMessageReceiver.buffer.length > 0); }], @"Buffer should be passed to service");
//}

- (void) testThatSendMessageCallsPutMesage
{
    [self.socketController sendMessage:@"IDDQD"];
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
