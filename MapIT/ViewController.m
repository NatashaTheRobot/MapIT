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
#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
{
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIView *dimmerView;
    
    NSMutableDictionary *addressesWithGestures;
    
}

- (void)displayInitialLocation;
- (void)addPinToLocation:(CLLocationCoordinate2D)location;

- (IBAction)addAddressWithButton:(id)sender;
- (IBAction)changeMapType:(id)sender;

- (void)gestureRight:(id)sender;
- (void)gestureLeft:(id)sender;
- (void)gestureDown:(id)sender;
- (void)gestureUp:(id)sender;

- (void)pinLocationForAddressGesture:(NSString *)gestureDirection;


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
    containerView.layer.cornerRadius = 10;
    containerView.layer.masksToBounds = YES;
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
    if ([segue.destinationViewController isKindOfClass:[SettingsViewController class]] ) {
        
        ((SettingsViewController *)segue.destinationViewController).delegate = self;
        
    } else if ([segue.destinationViewController isKindOfClass:[AddressViewController class]]) {
        
        ((AddressViewController *)segue.destinationViewController).delegate = self;
        
    }
    
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

#pragma mark - Gesture Recognizers

- (void)setLocationsForGestures:(NSMutableDictionary *)addresses
{
    addressesWithGestures = addresses;
    
    NSArray *gestureDirections = @[@"right", @"left", @"up", @"down"];
    NSArray *selectors = @[@"gestureRight:", @"gestureLeft:", @"gestureUp:", @"gestureDown:"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:selectors forKeys:gestureDirections];
    
    for (NSString *direction in gestureDirections) {
        if ([addresses objectForKey:direction] ) {
            NSString *selectorName = [dictionary objectForKey:direction];
            UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:(NSSelectorFromString(selectorName))];
            recognizer.delegate = self;
            
            [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
            
            
            [mapView addGestureRecognizer:recognizer];
        }
    }
    
}

- (void)gestureRight:(id)sender
{
    [self pinLocationForAddressGesture:@"right"];
}

- (void)gestureLeft:(id)sender
{
    [self pinLocationForAddressGesture:@"left"];
}

- (void)gestureUp:(id)sender
{
    [self pinLocationForAddressGesture:@"up"];
}

- (void)gestureDown:(id)sender
{
    [self pinLocationForAddressGesture:@"down"];
}

- (void)pinLocationForAddressGesture:(NSString *)gestureDirection
{
    NSString *googleMapApiString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [addressesWithGestures objectForKey:gestureDirection]];
    NSString *encodedURLString = [googleMapApiString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSDictionary *firstResult = [responseDictionary objectForKey:@"results"][0];
                               NSDictionary *locationDictionary = [[firstResult objectForKey:@"geometry"] objectForKey:@"location"];
                               mapView.centerCoordinate = CLLocationCoordinate2DMake([[locationDictionary objectForKey:@"lat"] floatValue],
                                                                                     [[locationDictionary objectForKey:@"lng"] floatValue]);
                               [self addPinToLocation:mapView.centerCoordinate];
                           }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    otherGestureRecognizer.enabled = FALSE;
    return YES;
}


@end
