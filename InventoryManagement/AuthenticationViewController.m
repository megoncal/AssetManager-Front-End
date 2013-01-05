//
//  AuthenticationViewController.m
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "AuthenticationViewController.h"

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

//hide the keyboard from UITextField every time tableView is touched
- (void)hideKeyboard{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *email = (NSString*)[alertView textFieldAtIndex:0].text;
        NSError *error;
        [PFUser requestPasswordResetForEmail:email error:&error];
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset" message: [NSString stringWithFormat:@"An email with reset instructions has been sent to %@",email] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset" message: [NSString stringWithFormat:@"%@",[[error userInfo]objectForKey:@"error"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }

    }else if (buttonIndex == 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3 &&
        indexPath.row == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.delegate = self;
        alert.title = @"Enter Email";
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Ok"];
        alert.message = @"Please enter the email address for your account.";
        [alert show];
        
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString:@"enterApplication"]) {
        NSError *error;
        PFUser *user = [PFUser logInWithUsername:self.userName.text password:self.password.text error:&error];
        
        if (user) {
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
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"signUpApplication"]) {
        SignUpViewController *destViewControler = segue.destinationViewController;
        destViewControler.delegate = self;
    }else if ([segue.identifier isEqualToString:@"enterApplication"]){
        

    }

}

- (void) signUpViewControllerHasDone:(SignUpViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}



@end
