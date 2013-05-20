//
//  AddressViewController.m
//  MapIT
//
//  Created by Natasha Murashev on 5/20/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()
{
    __weak IBOutlet UITextField *addressTextField;
    
}
- (IBAction)mapItWithButton:(id)sender;

@end

@implementation AddressViewController

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

- (IBAction)mapItWithButton:(id)sender
{
    [addressTextField resignFirstResponder];
    
    NSString *googleMapApiString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", addressTextField.text];
    NSString *encodedURLString = [googleMapApiString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSDictionary *firstResult = [responseDictionary objectForKey:@"results"][0];
                               NSDictionary *locationDictionary = [[firstResult objectForKey:@"geometry"] objectForKey:@"location"];
                               addressTextField.text = nil;
                               [self.delegate displayLocation:locationDictionary];
                           }];

}
@end
