//
//  Camera.h
//  InventoryManagement
//
//  Created by Marcos Vilela on 12/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "InventoryManagementThirdViewController.h"


@interface InventoryManagementCameraViewController : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) id previusViewController;
@property (weak, nonatomic) UIImage *image;


- (void)useCameraRoll;
- (void)useCamera;

@end
