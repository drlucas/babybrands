//
//  ViewController.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-02.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//fixup nav bar
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:30.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
   
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background1.jpg"] forBarMetrics:UIBarMetricsDefault];
    label.textColor = [UIColor blackColor];
   // label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Baby Brands", @"");
    [label sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
