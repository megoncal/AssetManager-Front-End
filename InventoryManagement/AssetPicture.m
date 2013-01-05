//
//  AssetPicture.m
//  InventoryManager
//
//  Created by Marcos Vilela on 02/01/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "AssetPicture.h"

@implementation AssetPicture

- (void) changeAssetImageFromDocs: (NSString*) assetShortDescription{
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    self.oldImageFileName = self.imagefileName;
    
    self.oldImagePath = self.imagePath;
    
    [fileManager removeItemAtPath:self.imagePath error:NULL];
    
    self.imagePath = [self storeImageInApplicationDirectory:self.image usingShortDescription:assetShortDescription];
    
    self.status = 3; // changed
    
}

- (void) removeAssetImageFromDocs{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:self.imagePath error:NULL];
    
    self.status = 1; //(removed)

}

- (void) addAssetImageIntoDocs: (NSString *) assetShortDescription{
    
    self.imagePath = [self storeImageInApplicationDirectory:self.image usingShortDescription:assetShortDescription];
    
    self.status = 2; // (added);
    
}

- (NSString *) storeImageInApplicationDirectory: (UIImage *)image usingShortDescription: (NSString *)shortDescription{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3f);
    
    NSDate *localDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MMddyy";
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HHmmss";
    NSString *timeString = [timeFormatter stringFromDate: localDate];
    
    NSString *imageDataName = [NSString stringWithFormat:@"%@%@%@", shortDescription,dateString,timeString];
    
    self.imagefileName = imageDataName;
    
    NSString *filePath = [self documentsPathForFileName:imageDataName];
    
    [imageData writeToFile:filePath atomically:YES];
    
    return filePath;
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}

@end
