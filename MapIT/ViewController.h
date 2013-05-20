//
//  ViewController.h
//  MapIT
//
//  Created by Natasha Murashev on 5/20/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationDelegate.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, LocationDelegate>

@end
