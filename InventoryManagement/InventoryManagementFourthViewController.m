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
    self.timeOutDate = [NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]];
    [self createAndShowProgressHUD];
    [self.locationManager startUpdatingLocation];
}

- (void) createAndShowProgressHUD{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
	self.HUD.delegate = self;
    self.HUD.labelText = @"Locating";
    self.HUD.detailsLabelText = @"Most Accurate Position";
    self.HUD.square = YES;
    [self.HUD show:YES];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.HUD hide:YES];
    UIAlertView *erroAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [erroAlert show];
}

/*
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
*/

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval locationAge = -[eventDate timeIntervalSinceNow];
    
    if (locationAge > 10.0) return;
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (location.horizontalAccuracy < 0) return;
    
    // test the measurement to see if it is more accurate than the previous measurement
    if (self.bestEffortAtLocation == nil || self.bestEffortAtLocation.horizontalAccuracy > location.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = location;
        
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        
        NSDate *currentDate = [NSDate date];
        if (location.horizontalAccuracy <= self.locationManager.desiredAccuracy ||
            (currentDate >= self.timeOutDate)) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self.locationManager stopUpdatingLocation];
            [self.HUD hide:YES];
            [self exhibitMap:location.coordinate];
            InventoryManagementThirdViewController *previusViewController = self.previusViewController;
            previusViewController.coordinate = location.coordinate;
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
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
    self.locationManager = nil;
    self.bestEffortAtLocation = nil;
    self.map = nil;
    [self viewDidLoad];
}

@end
