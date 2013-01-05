//
//  InventoryManagementFifthViewController.h
//  InventoryManagement
//
//  Created by Marcos Vilela on 12/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryManagementCameraViewController.h"
#import "InventoryManagementThirdViewController.h"

@interface InventoryManagementFifthViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) id previusViewController;
@property (weak, nonatomic) UIImage *image;
@property (nonatomic) BOOL editMode;
@property (nonatomic) BOOL imageSelected;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *retakePicture;

- (IBAction)retakePressed:(id)sender;

@end
