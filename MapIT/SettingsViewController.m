//
//  SettingsViewController.m
//  MapIT
//
//  Created by Natasha Murashev on 5/20/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    __weak IBOutlet UITextField *rightAddressTextField;
    __weak IBOutlet UITextField *leftAddressTextField;
    __weak IBOutlet UITextField *upAddressTextField;
    __weak IBOutlet UITextField *downAddressTextField;
    
}

- (IBAction)saveWithButton:(id)sender;
@end

@implementation SettingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveWithButton:(id)sender
{
    NSMutableDictionary *addresses = [[NSMutableDictionary alloc] init];
    
    if (![rightAddressTextField.text isEqualToString:@""]) {
        [addresses setObject:rightAddressTextField.text forKey:@"right"];
    }
    
    if (![leftAddressTextField.text isEqualToString:@""]) {
        [addresses setObject:leftAddressTextField.text forKey:@"left"];
    }
    
    if (![upAddressTextField.text isEqualToString:@""]) {
        [addresses setObject:upAddressTextField.text forKey:@"up"];
    }
    
    if (![downAddressTextField.text isEqualToString:@""]) {
        [addresses setObject:downAddressTextField.text forKey:@"down"];
    }
    
    [self.delegate setLocationsForGestures:addresses];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
