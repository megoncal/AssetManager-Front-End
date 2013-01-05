//
//  InternetConnection.h
//  InventoryManager
//
//  Created by Marcos Vilela on 03/01/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface InternetConnection : NSObject


+(BOOL)reachable;

@end
