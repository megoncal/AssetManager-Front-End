//
//  InventoryData.m
//  InventoryManagement
//
//  Created by Marcos Vilela on 06/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "AssetData.h"

@implementation AssetData

- (PFObject *) pfObject{
    
    if(_pfObject == nil) _pfObject = [PFObject objectWithClassName:@"Asset"];
    
    return _pfObject;
}


- (AssetPicture *) picture{
    if (_picture == Nil) {
        _picture = [[AssetPicture alloc]init];
    }
    return _picture;
}


- (void) encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.shortDescription forKey:@"shortDescription"];
    [encoder encodeObject:self.longDescription forKey:@"longDescription"];
    [encoder encodeObject:self.manufacturer forKey:@"manufacturer"];
    [encoder encodeObject:self.manualAddress forKey:@"manualAddress"];
    [encoder encodeObject:self.barCodeNumber forKey:@"barCodeNumber"];
    [encoder encodeObject:self.picture.imagePath forKey:@"imagePath"];
    [encoder encodeDouble:self.latitude forKey:@"latitude"];
    [encoder encodeDouble:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.createDate forKey:@"createDate"];
    [encoder encodeObject:self.lastModificationDate forKey:@"lastModificationDate"];
    [encoder encodeObject:self.serverObjectId forKey:@"serverObjectId"];
    [encoder encodeObject:self.picture.imagefileName forKey:@"imagefileName"];
    [encoder encodeBool:self.assetDataSynced forKey:@"assetDataSynced"];
    [encoder encodeBool:self.picture.imageSynced forKey:@"imageSynced"];

}

- (id) initWithCoder:(NSCoder*)decoder {
    if (self = [super init]) {
        // If parent class also adopts NSCoding, replace [super init]
        // with [super initWithCoder:decoder] to properly initialize.
        // NOTE: Decoded objects are auto-released and must be retained
        self.shortDescription = [decoder decodeObjectForKey:@"shortDescription"];
        self.longDescription = [decoder decodeObjectForKey:@"longDescription"];
        self.manufacturer = [decoder decodeObjectForKey:@"manufacturer"];
        self.manualAddress = [decoder decodeObjectForKey:@"manualAddress"];
        self.barCodeNumber = [decoder decodeObjectForKey:@"barCodeNumber"];
        self.picture.imagePath = [decoder decodeObjectForKey:@"imagePath"];
        self.latitude = [decoder decodeDoubleForKey:@"latitude"];
        self.longitude = [decoder decodeDoubleForKey:@"longitude"];
        self.createDate = [decoder decodeObjectForKey:@"createDate"];
        self.lastModificationDate = [decoder decodeObjectForKey:@"lastModificationDate"];
        self.serverObjectId = [decoder decodeObjectForKey:@"serverObjectId"];
        self.picture.imagefileName = [decoder decodeObjectForKey:@"imagefileName"];
        self.picture.imageSynced = [decoder decodeBoolForKey:@"imageSynced"];
        self.assetDataSynced = [decoder decodeBoolForKey:@"assetDataSynced"];
    
    }
    return self;
}


- (void) synchronizeAssetWithServer {
    
    if (self.picture.image != nil) {
        NSData *imageData = UIImageJPEGRepresentation(self.picture.image, 0.3f);
        
        PFFile *imageFile = [PFFile fileWithName:self.picture.imagefileName data:imageData];
        
        NSError *error;
        
        [imageFile save:&error];
        
        if (!error) {
            
            self.picture.imageSynced = YES;
            
            [self.pfObject setObject:imageFile forKey:@"image"];
            
            [self populateAssetPfObject];
            
            NSError *secondError;
            
            [self.pfObject save:&secondError];
            
            if (!secondError) {
                self.serverObjectId = self.pfObject.objectId;
                self.assetDataSynced = YES;
            }
        }
    }
    else{
        
        [self populateAssetPfObject];
        
        NSError *error;
        
        [self.pfObject save:&error];
        
        if(!error){
            self.serverObjectId = self.pfObject.objectId;
            self.assetDataSynced = YES;
        }
        
    }
}

- (void) populateAssetPfObject {
    
    if ([self.picture.imagefileName length] > 0)
        [self.pfObject setObject:self.picture.imagefileName forKey:@"imagefileName"];
    
    if ([self.shortDescription length] > 0)
        [self.pfObject setObject:self.shortDescription forKey:@"shortDescription"];
    
    if ([self.longDescription length] > 0)
        [self.pfObject setObject:self.longDescription forKey:@"longDescription"];
    
    if (self.lastModificationDate)
        [self.pfObject setObject:self.lastModificationDate forKey:@"lastModificationDate"];
    
    if ([self.manufacturer length] > 0)
        [self.pfObject setObject:self.manufacturer forKey:@"manufacturer"];
    
    if ([self.barCodeNumber length] > 0)
        [self.pfObject setObject:self.barCodeNumber forKey:@"barCodeNumber"];
    
    if ([self.manualAddress length] > 0)
        [self.pfObject setObject:self.manualAddress forKey:@"manualAddress"];
    
    if (self.createDate)
        [self.pfObject setObject:self.createDate forKey:@"createDate"];
    
    if (self.lastModificationDate)
        [self.pfObject setObject:self.lastModificationDate forKey:@"lastModificationDate"];
    
    if (self.latitude != 0)
        [self.pfObject setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    
    if (self.longitude != 0)
        [self.pfObject setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    
    self.pfObject.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

}

- (void) createInventoryDataWithParserObject: (PFObject *) pfObject{

    self.shortDescription = [pfObject objectForKey:@"shortDescription"];
    self.longDescription = [pfObject objectForKey:@"longDescription"];
    self.lastModificationDate = [pfObject objectForKey:@"lastModificationDate"];
    self.manufacturer = [pfObject objectForKey:@"manufacturer"];
    self.barCodeNumber = [pfObject objectForKey:@"barCodeNumber"];
    self.manualAddress = [pfObject objectForKey:@"manualAddress"];
    self.createDate = [pfObject objectForKey:@"createDate"];
    self.lastModificationDate = [pfObject objectForKey:@"lastModificationDate"];
    self.latitude = [(NSNumber*)[pfObject objectForKey:@"latitude"] doubleValue];
    self.longitude = [(NSNumber*)[pfObject objectForKey:@"longitude"] doubleValue];
    self.serverObjectId = [pfObject objectForKey:@"objectId"];
    self.picture.imagefileName = [pfObject objectForKey:@"imagefileName"];
    self.pfObject = pfObject;
    self.assetDataSynced = YES;

    //image file
    
    if ([self.picture.imagefileName length] >0 ) {
        
        self.picture.imageSynced = YES;
        
        PFFile *theImage = [pfObject objectForKey:@"image"];
        NSData *imageData = [theImage getData];
        
        NSFileManager *fileManger = [[NSFileManager alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath =  [documentsPath stringByAppendingPathComponent:self.picture.imagefileName];
        
        self.picture.imagePath = filePath;
        
        if (![fileManger fileExistsAtPath:self.picture.imagePath]) {
            [imageData writeToFile:self.picture.imagePath atomically:YES];
        }

    }
    
    
}
@end
