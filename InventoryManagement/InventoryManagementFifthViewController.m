//
//  InventoryManagementFifthViewController.m
//  InventoryManagement
//
//  Created by Marcos Vilela on 12/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "InventoryManagementFifthViewController.h"

@interface InventoryManagementFifthViewController ()

@property (strong,nonatomic) InventoryManagementCameraViewController *camera;


@end

@implementation InventoryManagementFifthViewController

- (InventoryManagementCameraViewController*) camera{
    if(_camera==nil){
       _camera = [[InventoryManagementCameraViewController alloc]init];
        _camera.previusViewController = self;
    }
    return _camera;
}


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
    self.imageView.image = self.image;
    if(!self.editMode)
        [self.retakePicture setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retakePressed:(id)sender {
    [self.camera useCamera];
}

- (void) viewDidDisappear:(BOOL)animated{
    
    InventoryManagementThirdViewController *previusViewControler = self.previusViewController;
    if(self.imageView.image &&
       self.imageSelected == YES){
        
        if (previusViewControler.imageButton.currentBackgroundImage)
            previusViewControler.imageChanged = YES;
        [previusViewControler.imageButton setBackgroundImage:self.imageView.image forState:UIControlStateNormal];
       
        
    }else if(self.imageView.image &&
              self.imageSelected==NO){
        
    }
    

}

@end
