//
//  InventoryManagementFirstViewController.h
//  InventoryManagement
//
//  Created by Marcos Vilela on 06/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryManagementThirdViewController.h"
#import <Parse/Parse.h>
#import "AssetData.h"
#import "MBProgressHUD.h"
#import "InternetConnection.h"
#import "AuthenticationViewController.h"


@interface InventoryManagementFirstViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, MBProgressHUDDelegate, InventoryManagementThirdViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *inventoryListArray;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) MBProgressHUD *HUD;





- (void)setEditing:(BOOL)editing animated:(BOOL)animated;


@end


