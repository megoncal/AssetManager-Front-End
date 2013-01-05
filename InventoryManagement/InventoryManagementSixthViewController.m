//
//  InventoryManagementSixthViewController.m
//  InventoryManager
//
//  Created by Marcos Vilela on 26/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "InventoryManagementSixthViewController.h"

@interface InventoryManagementSixthViewController ()

@end

@implementation InventoryManagementSixthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emailButtonPressed:(id)sender {
    
    if([MFMailComposeViewController canSendMail]){
        
        // Email Subject
        NSString *emailTitle = @"Contact About Asset Manager";
        
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"vilelam@gmail.com"];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }else{
        UIAlertView *erroAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device not configured to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [erroAlert show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView *alert;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alert = [[UIAlertView alloc]initWithTitle:@"Info"
                                              message:@"Mail cancelled"
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc]initWithTitle:@"Info"
                                              message:@"Mail saved"
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            break;
        case MFMailComposeResultSent:
            alert = [[UIAlertView alloc]initWithTitle:@"Info"
                                              message:@"Mail sent"
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                              message:[NSString stringWithFormat:@"Mail sent failure: %@",[error localizedDescription]]
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            break;
        default:
            break;
    }
    
    [alert show];
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
