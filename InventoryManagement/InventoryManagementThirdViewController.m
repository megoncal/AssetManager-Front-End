//
//  InventoryManagementThirdViewController.m
//  InventoryManagement
//
//  Created by Marcos Vilela on 06/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "InventoryManagementThirdViewController.h"

@interface InventoryManagementThirdViewController ()



@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionHeader;
@property (weak, nonatomic) IBOutlet UITextField *shortDescription;
@property (weak, nonatomic) IBOutlet UITextView *longDescription;
@property (weak, nonatomic) IBOutlet UITextField *manualAddress;
@property (weak, nonatomic) IBOutlet UITextField *BarCodeNumber;
@property (weak, nonatomic) IBOutlet UITextField *manufacturer;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) UITextField *activeField;
@property (strong, nonatomic) UIBarButtonItem *copiedLeftItem;
@property (strong, nonatomic) UIBarButtonItem *copiedRightItem;
@property (strong, nonatomic) InventoryManagementCameraViewController *camera;


- (void)keyboardWillBeHidden: (NSNotification *)aNotification;
- (void)keyboardWasShown:(NSNotification *)aNotification;
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textFieldChangedAction:(UITextField *)textField;
- (IBAction)editPressed;
- (void)configureView;
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (void)doneEdit;
- (void)cancelEdit;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)populateDataOnScreenFields;




@end

@implementation InventoryManagementThirdViewController

@synthesize delegate=_delegate;

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
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self populateDataOnScreenFields];
}

- (InventoryManagementCameraViewController *)camera{
    if(_camera==nil) {
        _camera = [[InventoryManagementCameraViewController alloc]init];
        _camera.previusViewController=self;
    }
    return _camera;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    //make the image button rounded
    self.imageButton.layer.cornerRadius = 10;
    self.imageButton.layer.masksToBounds = YES;
    
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //register keyboard notifications
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWasShown:)
                                                name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillBeHidden:)
                                                name:UIKeyboardWillHideNotification object:nil];
    
    //configure textFields to send changed Action
    [self.shortDescription addTarget:self action:@selector(textFieldChangedAction:) forControlEvents:UIControlEventEditingChanged];
    [self.manufacturer addTarget:self action:@selector(textFieldChangedAction:) forControlEvents:UIControlEventEditingChanged];
    [self.barCodeButton addTarget:self action:@selector(textFieldChangedAction:) forControlEvents:UIControlEventEditingChanged];
    [self.manualAddress addTarget:self action:@selector(textFieldChangedAction:) forControlEvents:UIControlEventEditingChanged];
    
    //initiate location and barcode get disabled
    self.barCodeButton.enabled = NO;
    self.LocationButton.enabled = NO;

    //if sender is UIBarButton its a new Item
    if ([self.sender isKindOfClass:[UIBarButtonItem class]]){
        self.newItem=YES;
        self.longDescription.editable=YES;
        self.inventoryData = [[AssetData alloc]init];
        [self editPressed];
    }//its an existed item to be displayed
    else{
        //set the longDescription field to read-only mode
        self.longDescription.editable=NO;
        //define the variable that is going to be checked by the delegate method (textFieldShouldBeginEditing)
        self.editMode = NO;
        self.newItem = NO;
    }
}


//handle keyboard notification
- (void)keyboardWasShown:(NSNotification *)aNotification{
   
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.tableView.bounds;
    aRect.size.height -= kbSize.height;
    CGRect activeRect = [self.activeField convertRect:self.activeField.frame toView:self.tableView];
    
    if (!CGRectContainsPoint(aRect,activeRect.origin) ) {
        UITableViewCell *cell = (UITableViewCell*)[self.activeField superview];
        CGPoint scrollPoint = CGPointMake(0.0, activeRect.origin.y-kbSize.height+cell.bounds.size.height);
        [self.tableView setContentOffset:scrollPoint animated:YES];
    }

}
//handle keyboard notification
- (void)keyboardWillBeHidden: (NSNotification *)aNotification{

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
}

//handle the textFields changed action
- (void)textFieldChangedAction:(UITextField *)textField
{
    if(textField.text.length>0){
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else{
        if(self.shortDescription.text.length==0 &&
           self.latitude.text.length==0 &&
           self.longitude.text.length==0 &&
           self.manufacturer.text == 0 &&
           self.BarCodeNumber.text == 0 &&
           self.manualAddress.text == 0){
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(self.editMode){
        if([textField isEqual:self.latitude] ||
           [textField isEqual:self.longitude] ||
           [textField isEqual:self.shortDescriptionHeader]){
            return NO;
        }else{
            return YES;
        }
    }
    else{
        return NO;
    }
}

// handle the textFieldDidBeging Editing event
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

// handle the textFieldDidEndEditing Editing event
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

//hide the keyboard from UITextField every time tableView is touched
- (void)hideKeyboard{
    [self.shortDescription resignFirstResponder];
    [self.longDescription resignFirstResponder];
    [self.manufacturer resignFirstResponder];
    [self.BarCodeNumber resignFirstResponder];
    [self.manualAddress resignFirstResponder];
}

//hide the keyboard from the UITextField fields.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//hide the keyboard from the object textView (long Description)
/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
 */

- (IBAction)editPressed{
    self.editMode = YES;
    self.copiedLeftItem = self.navigationItem.leftBarButtonItem;
    self.copiedRightItem = self.navigationItem.rightBarButtonItem;
    self.longDescription.editable=YES;
    self.barCodeButton.enabled = YES;
    self.LocationButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEdit)];
    if (self.newItem) [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)doneEdit
{
   
    [self hideKeyboard];
    
    self.navigationItem.leftBarButtonItem = self.copiedLeftItem;
    self.navigationItem.rightBarButtonItem = self.copiedRightItem;
    self.editMode = NO;
    self.inventoryData.shortDescription = self.shortDescription.text;
    self.inventoryData.longDescription = self.longDescription.text;
    self.inventoryData.barCodeNumber = self.BarCodeNumber.text;
    self.inventoryData.manualAddress = self.manualAddress.text;
    self.inventoryData.manufacturer = self.manufacturer.text;
    
    if(self.imageButton.currentBackgroundImage){
        self.inventoryData.picture.image = self.imageButton.currentBackgroundImage;
        
        if (self.inventoryData.picture.imagePath == nil){
            [self.inventoryData.picture addAssetImageIntoDocs:self.inventoryData.shortDescription];
        }else if (self.inventoryData.picture.imagePath != nil &&
                  self.imageChanged){
            [self.inventoryData.picture changeAssetImageFromDocs:self.inventoryData.shortDescription];
        }
        
    }
    if (self.newItem) {
        self.inventoryData.createDate = [NSDate date];
        self.inventoryData.lastModificationDate = [NSDate date];
    }else{
        self.inventoryData.lastModificationDate = [NSDate date];
    }
    
    self.inventoryData.latitude = self.coordinate.latitude;
    self.inventoryData.longitude = self.coordinate.longitude;
    
    [self.inventoryListArray addObject:self.inventoryData];
    
    //synchronize with parse.com using the MBProgressHUD
    [self createProgressHUDAndSynchronizeAssetWithServer];

}

- (void) createProgressHUDAndSynchronizeAssetWithServer{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	
	self.HUD.delegate = self;
	self.HUD.labelText = @"Saving";
	self.HUD.detailsLabelText = @"updating server";
	self.HUD.square = YES;
    
    [self.HUD show:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if ([InternetConnection reachable]) {
            [self.inventoryData synchronizeAssetWithServer];
        }
        [self.HUD hide:YES];
       
        [[self delegate] inventoryManagementThirdViewControllerHasDone:self];
    });
    
}


- (void)cancelEdit
{
    if(self.newItem){
        [[self delegate] inventoryManagementThirdViewControllerHasDone:self];
    }else{
        self.editMode = NO;
        self.barCodeButton.enabled=NO;
        self.LocationButton.enabled=NO;
        
        self.navigationItem.leftBarButtonItem = self.copiedLeftItem;
        self.navigationItem.rightBarButtonItem = self.copiedRightItem;
        [self populateDataOnScreenFields];
    }
}

- (void)populateDataOnScreenFields
{
    if ([self.shortDescription.text length] == 0) {
        self.shortDescription.text = self.inventoryData.shortDescription;
        self.shortDescriptionHeader.text = self.inventoryData.shortDescription;
    }
    if([self.longDescription.text length] == 0)
        self.longDescription.text = self.inventoryData.longDescription;
    
    if([self.manualAddress.text length] == 0)
        self.manualAddress.text = self.inventoryData.manualAddress;
    
    if([self.BarCodeNumber.text length] == 0)
        self.BarCodeNumber.text = self.inventoryData.barCodeNumber;
    
    if([self.manufacturer.text length] == 0)
        self.manufacturer.text = self.inventoryData.manufacturer;
    
    
    if (self.coordinate.latitude && self.coordinate.longitude){
        
        self.latitude.text = [NSString stringWithFormat: @"%+.6f",
                              self.coordinate.latitude];
        self.longitude.text = [NSString stringWithFormat: @"%+.6f",
                               self.coordinate.longitude];
    }
    else if (self.inventoryData.latitude && self.inventoryData.longitude){
        
        self.latitude.text = [NSString stringWithFormat: @"%+.6f",
                              self.inventoryData.latitude];
        self.longitude.text = [NSString stringWithFormat: @"%+.6f",
                               self.inventoryData.longitude];
        
        CLLocationCoordinate2D temp;
        temp.longitude = self.inventoryData.longitude;
        temp.latitude = self.inventoryData.latitude;
        self.coordinate = temp;
        
    }
    
    if (self.imageButton.currentBackgroundImage == nil &&
        self.inventoryData.picture.imagePath != nil){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            UIImage *image = [UIImage imageWithContentsOfFile:self.inventoryData.picture.imagePath];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
            });
            
        });
        
    }else if (self.imageButton.currentBackgroundImage == nil &&
              self.inventoryData.picture.imagePath == nil){
        [self.imageButton setTitle:@"Asset Picture" forState:UIControlStateNormal];
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"getCoordinates"]) {
        InventoryManagementFourthViewController *destViewController = segue.destinationViewController;
        destViewController.previusViewController = self;
        destViewController.hidesBottomBarWhenPushed=YES;
    }
    else if([segue.identifier isEqualToString:@"showPicture"]){
        InventoryManagementFifthViewController *destViewController = segue.destinationViewController;
        destViewController.image = self.imageButton.currentBackgroundImage;
        destViewController.hidesBottomBarWhenPushed=YES;
        destViewController.previusViewController = self;
        if (self.editMode) {
            destViewController.editMode = self.editMode;
        }
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([sender isEqual:self.imageButton])
    {
        if(self.editMode &&
           self.imageButton.currentBackgroundImage == nil){
            [self.camera useCamera];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.shortDescription]){
        NSString *str = textField.text;
        str = [str stringByReplacingCharactersInRange:range withString:string];
        self.shortDescriptionHeader.text = str;
    }
    return YES;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2 &&
        indexPath.row == 0) {
        [self sendEmail];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
}

- (void)sendEmail{

    if([MFMailComposeViewController canSendMail]){
        
        // Email Subject
        NSString *emailTitle = self.shortDescription.text;
        
        
        NSString *latitude = [NSString stringWithFormat: @"%+.6f",
                              self.coordinate.latitude];
        
        NSString *longitude = [NSString stringWithFormat: @"%+.6f",
                               self.coordinate.longitude];
        
        
        NSString *coordinateString = [NSString stringWithFormat:@"%@ Latitude. %@ Longitude.", latitude, longitude];
        
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"<p><strong>Short Description: </strong>%@<strong></strong></p><p><strong>manufacturer: </strong>%@</p><p><strong>Coordinates: </strong>%@<strong> </strong></p><p><strong>Serial: </strong>%@<strong></strong></p><p><strong>Manual URL: </strong>%@<strong></strong></p><p><strong>Long Description: </strong>%@<strong></strong></p>", self.shortDescription.text, self.manufacturer.text,coordinateString, self.BarCodeNumber.text, self.manualAddress.text, self.longDescription.text];
        
        // To address
//        NSArray *toRecipents = [NSArray arrayWithObject:@""];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:YES];
//        [mc setToRecipients:toRecipents];
        
        if(self.imageButton.currentBackgroundImage) {
             NSData *imageData = UIImageJPEGRepresentation(self.imageButton.currentBackgroundImage, 0.3f);
            [mc addAttachmentData:imageData mimeType: @"image/jpeg." fileName:[NSString stringWithFormat:@"%@",self.shortDescription.text]];
        }
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



- (IBAction)barCodePressed:(id)sender{

    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    
    [self presentViewController:reader animated:YES completion:NULL];

}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in results)
        break;
    self.BarCodeNumber.text = symbol.data;
    [picker dismissViewControllerAnimated:YES completion:Nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 1){
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        [timeFormat setDateFormat:@"HH:mm:ss"];
    
        NSString *theDate;
        NSString *theTime;
        
        if (self.inventoryData.lastModificationDate != nil) {
            theDate  = [dateFormat stringFromDate:self.inventoryData.lastModificationDate];
            theTime = [timeFormat stringFromDate:self.inventoryData.lastModificationDate];
            return [NSString stringWithFormat:@"Last Modified: %@ %@", theDate, theTime];
        }
        
    }
    return @"";
}




@end

