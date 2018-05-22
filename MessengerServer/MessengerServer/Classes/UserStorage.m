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
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation UserStorage

- (instancetype) init
{
    self = [super init];
    
    _users = [[NSMutableArray alloc] init];
    _concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    return self;
}

- (void) addUser:(User *)user
{
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self.users addObject:user];
    });
}

- (void) removeUser:(User *)user
{
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self.users removeObject:user];
    });
}

- (User *) findUserWithPhoneNumber:(NSString *)phoneNumber
{
    __block User *searchingUser;
    
    dispatch_sync(self.concurrentQueue, ^{
        for (User *user in self.users)
        {
            if([user.phoneNumber isEqualToString:phoneNumber])
            {
                searchingUser = user;
                break;
            }
        }
    });
    
    return searchingUser;
}

- (NSMutableArray<User *> *)allUsers
{
    return [self.users copy];
}

@end
