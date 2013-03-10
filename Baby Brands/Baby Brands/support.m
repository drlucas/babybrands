//
//  support.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-02.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "support.h"
#import "GameKit/GameKit.h"

@interface support ()

{
    
}


@end

@implementation support {
   
    IBOutlet UIImageView *countryflag;
    IBOutlet UISegmentedControl *changecountry;
}

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
	
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.243 green:0.125 blue:0.345 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:30.0];
    label.textColor = [UIColor whiteColor]; 
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Support", @"");
    [label sizeToFit];
    
    // Get user preferences
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* countrypref = [defaults stringForKey:@"country_preference"];
    UIImage *flagimage;
        
    if ([countrypref isEqualToString:@"United States"]){
        //   NSLog( @"Pref: %@",countrypref);
        // display US flag
        flagimage = [UIImage imageNamed: @"United-States-Flag-icon.png"];
    }
    
    if ([countrypref isEqualToString:@"Canada"])
        //dislay CA flag
    {
        flagimage = [UIImage imageNamed: @"Canada-Flag-icon.png"];
        changecountry.selectedSegmentIndex = 1;
        //NSLog( @"Pref: %@",countrypref);
    }
    [countryflag setImage:flagimage];

}



- (IBAction)showgame:(id)sender
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
        gameCenterController.leaderboardCategory = @"Victories";
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)defaultschanged:(id)sender {
    // NSLog(@"Value is %i", Segmentcountry.selectedSegmentIndex);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSString* countrypref = [defaults stringForKey:@"country_preference"];
    UIImage *flagimage;
    
	if(changecountry.selectedSegmentIndex == 0){  //USA
        NSString *defaultcountry = @"United States";
        [defaults setObject:defaultcountry forKey:@"country_preference"];
        [defaults synchronize];
        flagimage = [UIImage imageNamed: @"United-States-Flag-icon.png"];
       // UIAlertView *alert = [[UIAlertView alloc]
      //                        initWithTitle:@"Country Changed" message:@"You need to restart the app for the change to take effect" delegate:nil
      //                        cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
      //  [alert show];
        
	}
	if(changecountry.selectedSegmentIndex == 1){ // Canada
        NSString *defaultcountry = @"Canada";
        [defaults setObject:defaultcountry forKey:@"country_preference"];
        [defaults synchronize];
        flagimage = [UIImage imageNamed: @"Canada-Flag-icon.png"];
       // UIAlertView *alert = [[UIAlertView alloc]
       //                       initWithTitle:@"Country Changed" message:@"You need to restart the app for the change to take effect" delegate:nil
       //                       cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
       // [alert show];
        
        
	}
    [countryflag setImage:flagimage];
}

- (IBAction)colorfulname:(UIButton *)sender {
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://omg.yahoo.com/blogs/celeb-news/holly-madison-gives-newborn-daughter-colorful-name-194527656.html"]];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
