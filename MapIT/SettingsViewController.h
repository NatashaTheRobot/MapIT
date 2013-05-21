//
//  SettingsViewController.h
//  MapIT
//
//  Created by Natasha Murashev on 5/20/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsDelegate.h"

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) id<SettingsDelegate>delegate;

@end
