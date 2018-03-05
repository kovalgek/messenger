//
//  UserStorage.h
//  MessengerServer
//
//  Created by Anton Kovalchuk on 05.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserStorage : NSObject

- (void) addUser:(User *)user;
- (void) removeUser:(User *)user;
- (User *) findUserWithPhoneNumber:(NSString *)phoneNumber;
- (NSMutableArray<User*>*)allUsers;

@end
