//
//  UserStorageTests.m
//  MessengerServerTests
//
//  Created by Anton Kovalchuk on 05.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserStorage.h"
#import "User.h"

@interface UserStorageTests : XCTestCase
@property (nonatomic, strong) UserStorage *userStorage;
@end

@implementation UserStorageTests

- (void)setUp
{
    [super setUp];
    self.userStorage = [[UserStorage alloc] init];
}

- (void)tearDown
{
    self.userStorage = nil;
    [super tearDown];
}

- (void) testThatUserStorageExists
{
    XCTAssertNotNil(self.userStorage, @"Should be able to create UserStorage instance");
}

- (void) testThatPossibleToAddAndRemoveUserInUserStorage
{
    XCTAssert([[self.userStorage allUsers] count] == 0, @"On init storage should be empty");
    
    User *user = [[User alloc] initWithPhoneNumber:@"123"];
    [self.userStorage addUser:user];
    
    XCTAssertTrue([self waitFor: ^{
        User *storedUser = [[self.userStorage allUsers] firstObject];
        return (BOOL)([storedUser.phoneNumber isEqualToString:user.phoneNumber]);
    }], @"Added element should be the same");
    
    [self.userStorage removeUser:user];
    
    XCTAssertTrue([self waitFor: ^{
        NSUInteger allUsersCount = [[self.userStorage allUsers] count];
        return (BOOL)(allUsersCount == 0);
    }], @"After deleting an only element storage should be empty");
}

- (void) testThatAddedElementCanBeFound
{
    User *user0 = [[User alloc] initWithPhoneNumber:@"123"];
    [self.userStorage addUser:user0];
    User *user1 = [[User alloc] initWithPhoneNumber:@"435345"];
    [self.userStorage addUser:user1];
    
    XCTAssertTrue([self waitFor: ^{
        User *user = [self.userStorage findUserWithPhoneNumber:@"123"];
        return (BOOL)([user.phoneNumber isEqualToString:@"123"]);
    }], @"Added element should be the same");
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
