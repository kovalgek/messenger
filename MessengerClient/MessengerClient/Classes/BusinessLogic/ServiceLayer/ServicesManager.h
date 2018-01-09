//
//  ServicesManager.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 02.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FramerType.h"
#import "ServiceType.h"

@interface ServicesManager : NSObject

@property (nonatomic, assign) NSUInteger socket;
@property (nonatomic, strong) id<FramerType> framer;
@property (nonatomic, strong) NSMutableArray <id<ServiceType>> *services;

- (void) addService:(id<ServiceType>)service;
- (void) removeService:(id<ServiceType>)service;

- (void) runMessagesLoop;

@end
