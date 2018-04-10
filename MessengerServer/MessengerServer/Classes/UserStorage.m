//
//  UserStorage.m
//  MessengerServer
//
//  Created by Anton Kovalchuk on 05.03.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "UserStorage.h"
#import "User.h"

@interface UserStorage()
@property (nonatomic, strong) NSMutableArray<User*> *users;
@end

@implementation UserStorage

- (instancetype) init
{
    self = [super init];
    
    _users = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) addUser:(User *)user
{
    [self.users addObject:user];
}

- (void) removeUser:(User *)user
{
    [self.users removeObject:user];
}

- (User *) findUserWithPhoneNumber:(NSString *)phoneNumber
{
    for (User *user in self.users)
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
    return [self.users copy];
}

@end
