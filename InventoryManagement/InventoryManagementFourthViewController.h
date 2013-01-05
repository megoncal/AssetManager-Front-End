//
//  InventoryManagementFourthViewController.h
//  InventoryManagement
//
//  Created by Marcos Vilela on 08/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "InventoryManagementThirdViewController.h"


@interface InventoryManagementFourthViewController : UIViewController <CLLocationManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (weak, nonatomic) id previusViewController;

- (IBAction)refreshCoordinates:(id)sender;
- (void)startStandardUpdates;
- (MKCoordinateSpan)initialSpanUsingCoordinates:(CLLocationCoordinate2D)coordinate;


@end
