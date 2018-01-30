//
//  RegistrationServiceTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 27.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RegistrationRequest.h"
#import "RegistrationResponse.h"
#import "RegistrationService.h"
#import "MockRegistrationDecoder.h"
#import "MockRegistrationEncoderWithError.h"
#import "MockRegistrationEncoder.h"
#import "MockRegistrationServiceDelegate.h"

@interface RegistrationServiceTests : XCTestCase
{
    RegistrationService *service;
    MockRegistrationEncoder *encoder;
    MockRegistrationEncoderWithError *encoderWithError;
    MockRegistrationDecoder *decoder;
    NSError *underlyingError;
    MockRegistrationServiceDelegate *delegate;
}
@end

@implementation RegistrationServiceTests

- (void)setUp
{
    [super setUp];
    
    delegate = [[MockRegistrationServiceDelegate alloc] init];
    
    encoder = [[MockRegistrationEncoder alloc] init];
    decoder = [[MockRegistrationDecoder alloc] init];
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    encoderWithError = [[MockRegistrationEncoderWithError alloc] init];
    encoderWithError.error = underlyingError;
    
    service = [[RegistrationService alloc] initWithEncoder:encoder
                                                   decoder:decoder];
    service.delegate = delegate;
    
}

- (void)tearDown
{
    service = nil;
    encoder = nil;
    decoder = nil;
    underlyingError = nil;
    encoderWithError = nil;
    delegate = nil;
    [super tearDown];
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(service.delegate = (id<RegistrationServiceDelegate>)[NSNull null], @"NSNull doesn't conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate
{
    XCTAssertNoThrow(service.delegate = delegate, @"Object conforming to the delegate protocol can be delegate");
}

- (void)testManagerAcceptsNilAsADelegate
{
    XCTAssertNoThrow(service.delegate = nil, @"It should be acceptable to use nil as an object's delegate");
}

- (void)testRegistrationPassesDataToEncoder
{
    RegistrationRequest *registrationRequest = [[RegistrationRequest alloc] initWithPhoneNumber:@"+3123309201"];
    [service registrateUserWithRegistrationRequest:registrationRequest];
    XCTAssertEqual(encoder.phoneNumber, @"+3123309201", @"Registration service should pass data to encoder");
}

- (void) testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    [service registrateUserWithPhoneNumberFailedWithError: underlyingError];
    XCTAssertFalse(underlyingError == [delegate fetchError], @"Error should be at the correct level of abstraction");
}

- (void) testErrorReturnedToDelegateDocumentsUnderlyingError
{
    [service registrateUserWithPhoneNumberFailedWithError: underlyingError];
    XCTAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], underlyingError, @"The underlying error should be available to client code");
}

- (void)testRegistrationBufferIsPassedToDecoder
{
    [service receivedBuffer: @"fake buffer"];
    XCTAssertEqualObjects(decoder.buffer, @"fake buffer", @"Downloaded buffer is sent to the decoder");
}

- (void)testDelegateNotifiedOfErrorWhenRegistrationDecoderFails
{
    decoder.dataToReturn = nil;
    decoder.errorToSet = underlyingError;
    [service receivedBuffer: @"fake buffer"];
    XCTAssertNotNil([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], @"The delegate should have found out about the error");
}

- (void)testDelegateNotToldAboutErrorWhenBufferReceived
{
    decoder.dataToReturn = [[RegistrationResponse alloc] initWithStatus:@""];
    [service receivedBuffer: @"fake buffer"];
    XCTAssertNil([delegate fetchError], @"No error should be received on success");
}

@end
