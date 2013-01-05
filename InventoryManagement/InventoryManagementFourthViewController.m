//
//  InventoryManagementFourthViewController.m
//  InventoryManagement
//
//  Created by Marcos Vilela on 08/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "InventoryManagementFourthViewController.h"

@interface InventoryManagementFourthViewController ()

@end

@implementation InventoryManagementFourthViewController

@synthesize locationManager = _locationManager;


- (CLLocationManager *)locationManager
{
    if(_locationManager==nil) _locationManager = [[CLLocationManager alloc]init];
    return _locationManager;
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
    
    if([self.previusViewController editMode]){
        if([CLLocationManager locationServicesEnabled]){
            [self startStandardUpdates];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        InventoryManagementThirdViewController *previusController = self.previusViewController;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = previusController.inventoryData.latitude;
        coordinate.longitude = previusController.inventoryData.longitude;
        
        [self exhibitMap:coordinate];
        
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startStandardUpdates{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *erroAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [erroAlert show];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    InventoryManagementThirdViewController *previusViewController = self.previusViewController;
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0){
        [manager stopUpdatingLocation];
       // previusViewController.inventoryData.coordinate = location.coordinate;
        previusViewController.coordinate = location.coordinate;
        [self exhibitMap:location.coordinate];
        [self.locationManager stopUpdatingLocation];
    }
    
}


- (MKCoordinateSpan) initialSpanUsingCoordinates:(CLLocationCoordinate2D)coordinate
{
    double miles = .1;
    double scalingFactor = ABS( (cos(2 * M_PI * coordinate.latitude / 360.0) ));
    MKCoordinateSpan initialSpan;
    initialSpan.latitudeDelta = miles/69.0;
    initialSpan.longitudeDelta = miles/(scalingFactor*69.0);
    return initialSpan;
}

- (void) exhibitMap:(CLLocationCoordinate2D) coordinate{
    MKCoordinateRegion coordinateRegion;
    coordinateRegion.center = coordinate;
    coordinateRegion.span = [self initialSpanUsingCoordinates:coordinate];
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.coordinate = coordinate;
    point.title = @"Coordinates";
    point.subtitle = [NSString stringWithFormat:@"Latitude: %+.6f \n Longitude: %+.6f ", coordinate.latitude, coordinate.longitude];
    [self.map setNeedsDisplay];
    [self.map setRegion:coordinateRegion];
    [self.map addAnnotation:point];
    [self.map selectAnnotation:point animated:YES];
}

- (IBAction) refreshCoordinates:(id)sender{
    [self.map setNeedsDisplay];
    [self viewDidLoad];
}

@end
