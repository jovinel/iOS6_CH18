//
//  BIDViewController.m
//  WhereAmI
//
//  Created by Crescens Techstars on 12/10/13.
//  Copyright (c) 2013 Crescens Techstars. All rights reserved.
//

#import "BIDViewController.h"
#import "BIDPlace.h"

@interface BIDViewController ()

@end

@implementation BIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    _mapView.showsUserLocation = YES;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    NSString *latitudeString = [NSString stringWithFormat:@"%g\u00B0", newLocation.coordinate.latitude];
    _latitudeLabel.text = latitudeString;
    
    NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0", newLocation.coordinate.longitude];
    _longitudeLabel.text = longitudeString;
    
    NSString *horizontalAccuracyString = [NSString stringWithFormat:@"%gm", newLocation.horizontalAccuracy];
    _horizontalAccuracyLabel.text = horizontalAccuracyString;
    
    NSString *altitudeString = [NSString stringWithFormat:@"%gm", newLocation.altitude];
    _altitudeLabel.text = altitudeString;
    
    NSString *verticalAccuracyString = [NSString stringWithFormat:@"%gm", newLocation.verticalAccuracy];
    _verticalAccuracyLabel.text = verticalAccuracyString;
    
    if (newLocation.verticalAccuracy < 0 || newLocation.horizontalAccuracy < 0) {
        // invalid accuracy
        return;
    }
    if (newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50) {
        // accuracy radius is so large, we don't want to use it
        return;
    }
    if (_startPoint == nil) {
        self.startPoint = newLocation;
        self.distanceFromStart = 0;
        
        BIDPlace *start = [[BIDPlace alloc] init];
        start.coordinate = newLocation.coordinate;
        start.title = @"Start Point";
        start.subtitle = @"This is where we started";
        
        [_mapView addAnnotation:start];
        MKCoordinateRegion region;
        region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 100, 100);
        
        [_mapView setRegion:region animated:YES];
        
    } else {
        self.distanceFromStart = [newLocation distanceFromLocation:_startPoint];
    }
    
    NSString *distanceString = [NSString stringWithFormat:@"%g", _distanceFromStart];
    _distanceTraveledLabel.text = distanceString;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting location" message:errorType delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];

}

@end
