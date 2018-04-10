//
//  DelimiterFramer.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 13.01.18.
//  Copyright © 2018 Anton Kovalchuk. All rights reserved.
//

#import "DelimiterFramer.h"
#import "ErrorHelper.h"

static const char DELIMITER = '\n';

@implementation DelimiterFramer

- (int) getNextMesageFromSocketStream:(FILE *)socketStream
                               buffer:(UInt8 *)buffer
                           bufferSize:(size_t)bufferSize
{
    NSLog(@"getNextMesageFromSocketStream 0 bufferSize=%lu",bufferSize);
    int count = 0;
    int nextChar = 0;
    while ((unsigned long)count < bufferSize)
    {
        nextChar = getc(socketStream);
        NSLog(@"getNextMesageFromSocketStream nextChar %c",nextChar);
        if (nextChar == EOF)
        {
            if (count > 0)
            {
                [ErrorHelper dieWithUserMessage:@"GetNextMsg()"
                                         detail:@"Stream ended prematurely"];
                NSLog(@"getNextMesageFromSocketStream 1");
            }
            else
            {
                NSLog(@"getNextMesageFromSocketStream 2");
                return -1;
            }
        }
        if (nextChar == DELIMITER)
        {
            NSLog(@"getNextMesageFromSocketStream 3");
            break;
        }
        buffer[count++] = nextChar;
    }
    if (nextChar != DELIMITER) // Out of space: count==bufSize
    {
        NSLog(@"getNextMesageFromSocketStream 4");
        return -count;
    }
    else // Found delimiter
    {
        NSLog(@"getNextMesageFromSocketStream 5");
        return count;
    }
}

/* Write the given message to the output stream, followed by
 * the delimiter. Return number of bytes written, or -1 on failure.
 */
- (int) putMessageToSocketStream:(FILE *)socketStream
                          buffer:(UInt8 *)buffer
                      bufferSize:(size_t)bufferSize
{
    NSLog(@"putMessageToSocketStream0");
    // Check for delimiter in message
    unsigned long i;
    for (i = 0; i < bufferSize; i++)
    {
        if (buffer[i] == DELIMITER)
        {
            return -1;
        }
    }
    NSLog(@"putMessageToSocketStream1");
    if (fwrite(buffer, 1, bufferSize, socketStream) != bufferSize)
    {
        return -1;
    }
    NSLog(@"putMessageToSocketStream2");
    fputc(DELIMITER, socketStream);
    fflush(socketStream);
    return (int)bufferSize;
}

@end
