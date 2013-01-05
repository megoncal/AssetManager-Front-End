//
//  InventoryData.h
//  InventoryManagement
//
//  Created by Marcos Vilela on 06/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "AssetPicture.h"


@interface AssetData : NSObject <NSCoding>

@property NSString *shortDescription;
@property NSString *longDescription;
@property NSDate *lastModificationDate;
@property NSString *manufacturer;
@property NSString *barCodeNumber;
@property NSString *manualAddress;
@property NSDate *createDate;
//@property NSDate *lastModifiedDate;
@property double latitude;
@property double longitude;
@property BOOL assetDataSynced;

@property (nonatomic,strong) AssetPicture *picture;

@property (nonatomic, strong) PFObject *pfObject;

//Parse.com variable
@property NSString *serverObjectId;

- (void) synchronizeAssetWithServer;
- (void) createInventoryDataWithParserObject: (PFObject *) pfObject;

@end
