//
//  UserStorageType.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 05.04.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
#import <Foundation/Foundation.h>
@class User;

@protocol UserStorageType

- (void) addUser:(User *)user;
- (void) removeUser:(User *)user;
- (User *) findUserWithPhoneNumber:(NSString *)phoneNumber;
- (NSMutableArray<User*>*)allUsers;

@end
