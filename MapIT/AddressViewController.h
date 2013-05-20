//
//  AddressViewController.h
//  MapIT
//
//  Created by Natasha Murashev on 5/20/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationDelegate.h"

@interface AddressViewController : UIViewController

@property (strong, nonatomic) id<LocationDelegate> delegate;

@end
