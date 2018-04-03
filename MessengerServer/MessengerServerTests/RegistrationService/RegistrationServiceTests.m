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
    MockRegistrationServiceDelegate *serviceDelegate;
}
@end

@implementation RegistrationServiceTests

- (void)setUp
{
    [super setUp];
    
    serviceDelegate = [[MockRegistrationServiceDelegate alloc] init];
    
    encoder = [[MockRegistrationEncoder alloc] init];
    decoder = [[MockRegistrationDecoder alloc] init];
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    encoderWithError = [[MockRegistrationEncoderWithError alloc] init];
    encoderWithError.error = underlyingError;
    
    service = [[RegistrationService alloc] initWithEncoder:encoder
                                                   decoder:decoder];
    service.serviceDelegate = serviceDelegate;
}

- (void)tearDown
{
    service = nil;
    encoder = nil;
    decoder = nil;
    underlyingError = nil;
    encoderWithError = nil;
    serviceDelegate = nil;
    [super tearDown];
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(service.serviceDelegate = (id<RegistrationServiceDelegate>)[NSNull null], @"NSNull doesn't conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate
{
    XCTAssertNoThrow(service.serviceDelegate = serviceDelegate, @"Object conforming to the delegate protocol can be delegate");
}

- (void)testManagerAcceptsNilAsADelegate
{
    XCTAssertNoThrow(service.serviceDelegate = nil, @"It should be acceptable to use nil as an object's delegate");
}

- (void)testRegistrationPassesDataToEncoder
{
    RegistrationResponse *registrationResponse = [[RegistrationResponse alloc] initWithStatus:@"200"];
    [service sendRegistrationResponseBackToUser:registrationResponse];
    XCTAssertEqual(encoder.status, @"200", @"Registration service should pass data to encoder");
}

- (void) testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    [service sendRegistrationResponseBackToUserFailedWithError: underlyingError];
    XCTAssertFalse(underlyingError == [serviceDelegate fetchError], @"Error should be at the correct level of abstraction");
}

- (void) testErrorReturnedToDelegateDocumentsUnderlyingError
{
    [service sendRegistrationResponseBackToUserFailedWithError: underlyingError];
    XCTAssertEqualObjects([[[serviceDelegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], underlyingError, @"The underlying error should be available to client code");
}

- (void)testRegistrationBufferIsPassedToDecoder
{
    [service receivedBuffer: @"fake buffer" forSocket:0];
    XCTAssertEqualObjects(decoder.buffer, @"fake buffer", @"Downloaded buffer is sent to the decoder");
}

- (void)testDelegateNotifiedOfErrorWhenRegistrationDecoderFails
{
    decoder.dataToReturn = nil;
    decoder.errorToSet = underlyingError;
    [service receivedBuffer: @"fake buffer" forSocket:0];
    XCTAssertNotNil([[[serviceDelegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], @"The delegate should have found out about the error");
}

- (void)testDelegateNotToldAboutErrorWhenBufferReceived
{
    decoder.dataToReturn = [[RegistrationRequest alloc] initWithPhoneNumber:@"123"];
    [service receivedBuffer: @"fake buffer" forSocket:0];
    XCTAssertNil([serviceDelegate fetchError], @"No error should be received on success");
}

@end
