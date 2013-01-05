//
//  AssetPicture.h
//  InventoryManager
//
//  Created by Marcos Vilela on 02/01/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AssetPicture : NSObject

@property NSString *imagePath;
@property UIImage *image;
@property NSString *imagefileName;
@property BOOL imageSynced;
@property (nonatomic, strong) PFObject *pfImageObject;
@property NSInteger status;
@property NSString *oldImageFileName;
@property NSString *oldImagePath;

- (void) changeAssetImageFromDocs:(NSString*) assetShortDescription;
- (void) removeAssetImageFromDocs;
- (void) addAssetImageIntoDocs: (NSString *) assetShortDescription;


@end
