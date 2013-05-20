//
//  ViewController.m
//  MapIT
//
//  Created by Natasha Murashev on 5/20/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "AddressViewController.h"

@interface ViewController ()
{
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIView *dimmerView;
    
}

- (void)displayInitialLocation;
- (void)addPinToLocation:(CLLocationCoordinate2D)location;

- (IBAction)addAddressWithButton:(id)sender;
- (IBAction)changeMapType:(id)sender;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self displayInitialLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayInitialLocation
{
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    
    CLLocationCoordinate2D location;
    location.latitude = 41.893740;
    location.longitude = -87.635330;
    
    MKCoordinateRegion region;
    region.span=span;
    region.center=location;
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
    
    [self addPinToLocation:location];
}

- (void)addPinToLocation:(CLLocationCoordinate2D)location
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    [mapView addAnnotation:annotation];
}

- (IBAction)addAddressWithButton:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        dimmerView.alpha = 0.5;
        containerView.alpha = 1;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((AddressViewController *)segue.destinationViewController).delegate = self;
}

- (void)displayLocation:(NSDictionary *)locationDictionary
{
    [UIView animateWithDuration:0.5 animations:^{
        containerView.alpha = 0;
        dimmerView.alpha = 0;
    }];
    mapView.centerCoordinate = CLLocationCoordinate2DMake([[locationDictionary objectForKey:@"lat"] floatValue],
                                                          [[locationDictionary objectForKey:@"lng"] floatValue]);
    [self addPinToLocation:mapView.centerCoordinate];

}

- (IBAction)changeMapType:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            mapView.mapType = MKMapTypeStandard;
            break;
    }
    
}

@end
