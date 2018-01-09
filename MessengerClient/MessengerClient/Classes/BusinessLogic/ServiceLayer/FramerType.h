//
//  FramerType.h
//  MessengerClient
//
//  Created by Anton Kovalchuk on 08.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

@protocol FramerType
- (int) getNextMesage; //(FILE *in, uint8_t *buffer, size_t bufferSize);
- (int) putMessage;    //(uint8_t buffer[], size_t messageSize, FILE *out);
@end
