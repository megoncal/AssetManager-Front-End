//
//  InternetConnection.m
//  InventoryManager
//
//  Created by Marcos Vilela on 03/01/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "InternetConnection.h"

@implementation InternetConnection

+ (BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"parse.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

@end
