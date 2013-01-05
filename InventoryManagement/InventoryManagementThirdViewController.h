//
//  InventoryManagementThirdViewController.h
//  InventoryManagement
//
//  Created by Marcos Vilela on 06/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetData.h"
#import "InventoryManagementFourthViewController.h"
#import "InventoryManagementFifthViewController.h"
#import "InventoryManagementCameraViewController.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "ZBarSDK.h"
#import "MBProgressHUD.h"
#import "InternetConnection.h"

@protocol InventoryManagementThirdViewControllerDelegate;

@interface InventoryManagementThirdViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,ZBarReaderDelegate, UITableViewDelegate, MBProgressHUDDelegate>{
    
    id delegate;
}

@property (weak, nonatomic) IBOutlet UIButton *barCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *LocationButton;
@property (strong, nonatomic) AssetData *inventoryData;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) id sender;
@property (weak, nonatomic) NSMutableArray *inventoryListArray;
@property (nonatomic) BOOL editMode;
@property (nonatomic) BOOL newItem;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) BOOL imageChanged;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (nonatomic, assign) id<InventoryManagementThirdViewControllerDelegate>delegate;



- (IBAction)barCodePressed:(id)sender;

@end


@protocol InventoryManagementThirdViewControllerDelegate <NSObject>

- (void) inventoryManagementThirdViewControllerHasDone:(InventoryManagementThirdViewController *) viewController;

@end
