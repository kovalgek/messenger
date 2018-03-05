//
//  UserStorage.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 05.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "UserStorage.h"

@interface UserStorage()
@end

@implementation UserStorage

+ (NSMutableArray<User*> *)users
{
    static NSMutableArray<User*> *users = nil;
    if (users == nil)
    {
        users = [[NSMutableArray alloc] init];
    }
    return users;
}

- (void) addUser:(User *)user
{
    [[[self class] users] addObject:user];
}

- (void) removeUser:(User *)user
{
    [[[self class] users] removeObject:user];
}

- (User *) findUserWithPhoneNumber:(NSString *)phoneNumber
{
    for (User *user in [[self class] users])
    {
        if([user.phoneNumber isEqualToString:phoneNumber])
        {
            return user;
        }
    }
    return nil;
}

- (NSMutableArray<User *> *)allUsers
{
    return [[[self class] users] copy];
}

@end
