//
//  Camera.m
//  InventoryManagement
//
//  Created by Marcos Vilela on 12/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "InventoryManagementCameraViewController.h"

@interface InventoryManagementCameraViewController ()

@property (nonatomic) BOOL newMedia;


@end

@implementation InventoryManagementCameraViewController 



- (void)useCameraRoll {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString*) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        InventoryManagementThirdViewController *vController = self.previusViewController;
        [vController presentViewController:imagePicker animated:YES completion:nil];
        self.newMedia = NO;
        
    }
    
}

- (void) useCamera {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType	= UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        if([self.previusViewController isKindOfClass:[InventoryManagementThirdViewController class]]){
            InventoryManagementThirdViewController *vController = self.previusViewController;
            [vController presentViewController:imagePicker animated:YES completion:nil];
        }else if([self.previusViewController isKindOfClass:[InventoryManagementFifthViewController class]]){
            InventoryManagementFifthViewController *vController = self.previusViewController;
            [vController presentViewController:imagePicker animated:YES completion:nil];
        }
        self.newMedia = YES;
    }
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    InventoryManagementThirdViewController *vController = self.previusViewController;
    [vController dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //reducing image size
        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
        [image drawInRect:CGRectMake(0, 0, 640, 960)];
        UIImage *smallImage;
        smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if([self.previusViewController isKindOfClass:[InventoryManagementThirdViewController class]]){
            InventoryManagementThirdViewController *previusViewController = self.previusViewController;
            [previusViewController dismissViewControllerAnimated:YES completion:nil];
            [previusViewController.imageButton setBackgroundImage:smallImage forState:UIControlStateNormal];
            [previusViewController.imageButton setTitle:@"" forState:UIControlStateNormal];
        }else if([self.previusViewController isKindOfClass:[InventoryManagementFifthViewController class]]){
            InventoryManagementFifthViewController *vController = self.previusViewController;
            [vController dismissViewControllerAnimated:YES completion:nil];
            vController.imageView.image = smallImage;
            vController.imageSelected = YES;
        }

    }
}

- (void) image:(UIImage *)image finishedSavingWithErro:(NSError*)error contextInfo:(void*)contextInfo
{
    if(error){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
