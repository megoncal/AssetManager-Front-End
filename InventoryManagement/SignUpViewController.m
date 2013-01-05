//
//  SignUpViewController.m
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];


}


- (void)viewWillAppear:(BOOL)animated{
    self.username.text = @"";
    self.password.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    [self.email resignFirstResponder];
}
- (void)hideKeyboard{
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    [self.email resignFirstResponder];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"enterApplication"]) {
        NSError *error;
        PFUser *user = [PFUser user];
        user.username = self.username.text;
        user.password = self.password.text;
        user.email = self.email.text;
        
        [user signUp:&error];
        
        if(!error){
            return YES;
        }else{
            NSString *errorString;
            errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            return NO;
        }
        
        
    }
    
    return  YES;
}

- (IBAction)cancelPressed:(id)sender {
    [[self delegate] signUpViewControllerHasDone:self];
}


@end
