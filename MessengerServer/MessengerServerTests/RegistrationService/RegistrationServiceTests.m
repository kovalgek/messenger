//
//  RegistrationServiceTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "RegistrationRequest.h"
#import "RegistrationResponse.h"
#import "RegistrationService.h"
#import "MockRegistrationDecoder.h"
#import "MockRegistrationEncoderWithError.h"
#import "MockRegistrationEncoder.h"
#import "MockRegistrationServiceDelegate.h"
#import "UserStorageType.h"

@interface RegistrationServiceTests : XCTestCase
@property (nonatomic, strong) RegistrationService *service;
@property (nonatomic, strong) MockRegistrationEncoder *encoder;
@property (nonatomic, strong) MockRegistrationEncoderWithError *encoderWithError;
@property (nonatomic, strong) MockRegistrationDecoder *decoder;
@property (nonatomic, strong) NSError *underlyingError;
@property (nonatomic, strong) MockRegistrationServiceDelegate *serviceDelegate;
@property (nonatomic, strong) id<UserStorageType> userStorage;
@end

@implementation RegistrationServiceTests

- (void)setUp
{
    [super setUp];
    
    self.serviceDelegate = [[MockRegistrationServiceDelegate alloc] init];
    
    self.encoder = [[MockRegistrationEncoder alloc] init];
    self.decoder = [[MockRegistrationDecoder alloc] init];
    self.userStorage = OCMProtocolMock(@protocol(UserStorageType));
    self.underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    self.encoderWithError = [[MockRegistrationEncoderWithError alloc] init];
    self.encoderWithError.error = self.underlyingError;
    
    self.service = [[RegistrationService alloc] initWithEncoder:self.encoder
                                                        decoder:self.decoder
                                                    userStorage:self.userStorage];
    self.service.serviceDelegate = self.serviceDelegate;
}

- (void)tearDown
{
    self.service = nil;
    self.encoder = nil;
    self.decoder = nil;
    self.underlyingError = nil;
    self.encoderWithError = nil;
    self.serviceDelegate = nil;
    self.userStorage = nil;
    [super tearDown];
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(self.service.serviceDelegate = (id<RegistrationServiceDelegate>)[NSNull null], @"NSNull doesn't conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate
{
    XCTAssertNoThrow(self.service.serviceDelegate = self.serviceDelegate, @"Object conforming to the delegate protocol can be delegate");
}

- (void)testManagerAcceptsNilAsADelegate
{
    XCTAssertNoThrow(self.service.serviceDelegate = nil, @"It should be acceptable to use nil as an object's delegate");
}

- (void)testRegistrationPassesDataToEncoder
{
    RegistrationResponse *registrationResponse = [[RegistrationResponse alloc] initWithStatus:@"200"];
    [self.service sendRegistrationResponseBackToUser:registrationResponse forSocket:1];
    XCTAssertEqual(self.encoder.status, @"200", @"Registration service should pass data to encoder");
}

- (void) testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    [self.service sendRegistrationResponseBackToUserFailedWithError: self.underlyingError];
    XCTAssertFalse(self.underlyingError == [self.serviceDelegate fetchError], @"Error should be at the correct level of abstraction");
}

- (void) testErrorReturnedToDelegateDocumentsUnderlyingError
{
    [self.service sendRegistrationResponseBackToUserFailedWithError: self.underlyingError];
    XCTAssertEqualObjects([[[self.serviceDelegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], self.underlyingError, @"The underlying error should be available to client code");
}

- (void)testRegistrationBufferIsPassedToDecoder
{
    [self.service receivedBuffer: @"fake buffer" forSocket:0];
    XCTAssertEqualObjects(self.decoder.buffer, @"fake buffer", @"Downloaded buffer is sent to the decoder");
}

- (void)testDelegateNotifiedOfErrorWhenRegistrationDecoderFails
{
    self.decoder.dataToReturn = nil;
    self.decoder.errorToSet = self.underlyingError;
    [self.service receivedBuffer: @"fake buffer" forSocket:0];
    XCTAssertNotNil([[[self.serviceDelegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], @"The delegate should have found out about the error");
}

- (void)testDelegateNotToldAboutErrorWhenBufferReceived
{
    self.decoder.dataToReturn = [[RegistrationRequest alloc] initWithPhoneNumber:@"123"];
    [self.service receivedBuffer: @"fake buffer" forSocket:0];
    XCTAssertNil([self.serviceDelegate fetchError], @"No error should be received on success");
}

@end
