//
//  main.m
//  MessengerClient
//
//  Created by Anton Kovalchuk on 26.12.17.
//  Copyright © 2017 Anton Kovalchuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TestAppDelegate.h"

int main(int argc, char * argv[]) {

    int returnValue;
    
    @autoreleasepool {
        BOOL inTests = (NSClassFromString(@"SenTestCase") != nil || NSClassFromString(@"XCTest") != nil);
        
        if (inTests)
        {
            //use a special empty delegate when we are inside the tests
            returnValue = UIApplicationMain(argc, argv, nil, @"TestAppDelegate");
        }
        else
        {
            //use the normal delegate
            returnValue = UIApplicationMain(argc, argv, nil, @"AppDelegate");
        }
    }
    
    return returnValue;
}
