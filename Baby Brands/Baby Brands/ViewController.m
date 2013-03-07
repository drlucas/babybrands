//
//  ViewController.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-02.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "ViewController.h"
#import "GameKit/GameKit.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//fixup nav bar
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.243 green:0.125 blue:0.345 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:30.0];
   // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    //label.textColor = [UIColor blackColor];
   label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Baby Brands", @"");
    [label sizeToFit];
    
    //start game center up
    [self authenticateLocalPlayer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//game center setup

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
        if (!error && viewcontroller)
        {
           // [[support sharedDelegate].viewController
            // presentViewController:viewcontroller animated:YES completion:nil];
        }
        else
        {
           //something bad happened
        }
        
    })];
}


@end
