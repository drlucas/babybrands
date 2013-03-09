//
//  popularnames.h
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-02.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "ViewController.h"

@interface popularnames : ViewController

{
    
    NSMutableArray *datesarray;
    NSString *dateselected;
    
    
}
@property (strong) IBOutlet UITableView *datetable;
@property (strong, nonatomic) IBOutlet UILabel *yearselected; // the year picked from uipicker will fill in here

@property (strong, nonatomic) IBOutlet UIView *yearlistcontainer;

@property (readwrite, copy) NSArray *datesarray;
//@property (readwrite, copy) NSString *dateselected;



@end
