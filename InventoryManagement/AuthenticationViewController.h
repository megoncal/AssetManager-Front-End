//
//  AuthenticationViewController.h
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "InventoryManagementFirstViewController.h"



@interface AuthenticationViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate, SignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end


