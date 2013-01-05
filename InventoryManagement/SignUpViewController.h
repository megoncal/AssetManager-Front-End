//
//  SignUpViewController.h
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol SignUpViewControllerDelegate;

@interface SignUpViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (nonatomic, assign) id<SignUpViewControllerDelegate>delegate;

- (IBAction)cancelPressed:(id)sender;



@end


@protocol SignUpViewControllerDelegate <NSObject>

- (void) signUpViewControllerHasDone: (SignUpViewController *) viewController;

@end