//
//  RegistrationDecoderTests.m
//  MessengerClientTests
//
//  Created by Anton Kovalchuk on 09.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RegistrationDecoder.h"

@interface RegistrationDecoderTests : XCTestCase
{
    RegistrationDecoder *decoder;
}
@end

@implementation RegistrationDecoderTests

- (void)setUp
{
    [super setUp];
    decoder = [[RegistrationDecoder alloc] init];
}

- (void)tearDown
{
    decoder = nil;
    [super tearDown];
}

- (void) testThatNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([decoder decodeRegistrationRequestFromBuffer:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testNilReturnedWhenBufferIsNotValid
{
    XCTAssertNil([decoder decodeRegistrationRequestFromBuffer:@"" error: NULL], @"This parameter should not be parsable");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([decoder decodeRegistrationRequestFromBuffer: @"" error: NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testInvalidBufferErrorSetWhenBufferIsEmpty
{
    NSError *error = nil;
    [decoder decodeRegistrationRequestFromBuffer: @"" error: &error];
    XCTAssert(error.code == RegistrationDecoderInvalidBufferError, @"An error occurred, we should be told");
}

- (void)testCantParseErrorWhenThereIsNoMagicWord
{
    NSError *error = nil;
    [decoder decodeRegistrationRequestFromBuffer: @"nomagic buffer" error: &error];
    XCTAssert(error.code == RegistrationDecoderCantParseBuffer, @"An error occurred, we should be told");
}

@end
