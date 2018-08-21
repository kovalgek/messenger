//
//  ServiceControllerType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 21.08.2018.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//
@protocol MessageReceiverType;

@protocol ServicesControllerType
- (void) addService:(id<MessageReceiverType>)service;
- (void) removeService:(id<MessageReceiverType>)service;
- (void) notifyServicesWithBuffer:(NSString *)receivedBuffer;
@end
