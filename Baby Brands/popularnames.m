//
//  popularnames.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-02.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "popularnames.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "DTCustomColoredAccessory.h"


@interface popularnames ()
- (IBAction)changesex:(id)sender;


@end

@implementation popularnames {
    
    IBOutlet UIPickerView *yearlist;
    IBOutlet UISegmentedControl *sex;
    NSInteger pickerrow;
    NSString *yearselect;

}

@synthesize datesarray;   //array to store years to display in popup selector
@synthesize yearlistcontainer; // to show/hide the years
@synthesize datetable; // table with rank, count, babyname



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
    label.font = [UIFont boldSystemFontOfSize:15.0];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Name Popularity", @"");
    [label sizeToFit];
    [self datesList]; // this will populate the popup button values
    //NSLog(@"Value is %i", sex.selectedSegmentIndex); 0 is male, 1 is female
    _yearselected.text =  @"1917"; //seed the default popup button with a value
   
   
   // [self popularlist];
   // [datetable reloadData];
}

-(NSMutableArray *) datesList {
    datesarray = [[NSMutableArray alloc] initWithCapacity:10];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* countrypref = [defaults stringForKey:@"country_preference"];
    // Create a FileManager object, we will use this to check the status of the database and to copy it over if required
	NSString *databaseName;
	NSString *databasePath;
    BOOL success = 0;
    databaseName = @"brandnames.sqlite";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
    if(success) {// nothing to be done because....//NSLog(@"Database already exists");
    }
    else
    {// If not then proceed to copy the database from the application to the users filesystem
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    };
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    FMResultSet *results;
    NSString *querystring;
    if ([countrypref isEqualToString:@"United States"]){
        //NSLog( @"Pref: %@",countrypref);
        querystring= [NSString stringWithFormat:@"SELECT DISTINCT year from usa"];
        
    }
    if ([countrypref isEqualToString:@"Canada"])
    {
       // NSLog( @"Pref: %@",countrypref);
        querystring= [NSString stringWithFormat:@"SELECT DISTINCT year from canada"];
    }
    results = [database executeQuery:querystring];
    int dateyear;
    NSNumber *datenumber;
    while([results next]) { 
        dateyear = [results intForColumn:@"year"];
        datenumber = [NSNumber numberWithInteger:dateyear];
        [datesarray addObject:datenumber];
    }
    [database close];
    return datesarray;
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
     // NSLog(@"dates: %i", datesarray.count);
    return datesarray.count;
  
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
   // NSLog(@"dates: ", [datesarray objectAtIndex:row]);
    return [NSString stringWithFormat:@"%@",[datesarray objectAtIndex:row]];
   // return [datesarray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerrow = [yearlist selectedRowInComponent:0];
    yearselect = [[datesarray objectAtIndex:pickerrow] stringValue];
    _yearselected.text =  yearselect;
    //[self earnerList];
    //[browsetable reloadData];
}

- (IBAction)hide40picker:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    yearlistcontainer.frame = CGRectMake(0, 550, 320, 224);
    [UIView commitAnimations];
}
- (IBAction)changeyear:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    yearlistcontainer.frame = CGRectMake(0, 300, 320, 224);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changesex:(id)sender {
    // NSLog(@"Value is %i", sex.selectedSegmentIndex);
    // do something if the sex changes (later on i'll do another reload of the table data)

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        //4 inch screen
     //   maxearners = 10;
        
    }
    else{
        //3.5 inch screen
     //   maxearners = 8;
    }
    
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"browsecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];}
    cell.textLabel.textColor = [UIColor whiteColor];
    
  //  Earner *earner = [theearners objectAtIndex:indexPath.row];
    NSString *fullname = [NSString stringWithFormat:@"me"];
    cell.textLabel.text = fullname;
    
    //cell.detailTextLabel.text = earner.lastname;
    //cell.textLabel.text = [browsemenu objectAtIndex:indexPath.row];  //from original array
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor whiteColor];
    cell.accessoryView =accessory;
    return cell;
}



- (void)viewDidUnload {
    sex = nil;
    [self setYearlistcontainer:nil];
    yearlist = nil;
    [self setYearselected:nil];
    [super viewDidUnload];
}
@end
