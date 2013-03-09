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
#import "names.h"


@interface popularnames ()
- (IBAction)changesex:(id)sender;


@end

@implementation popularnames {
    
    IBOutlet UIPickerView *yearlist;
    IBOutlet UISegmentedControl *sex;
    IBOutlet UIButton *changeyearbtn;
    
    NSInteger pickerrow;
    NSString *yearselect;
    NSMutableArray *babynames;   //array to store male and female top 10 in each year
    NSUserDefaults *defaults;
    NSString* countrypref;
    NSString *queryyear;
    
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
    
    //NSLog(@"Value is %i", sex.selectedSegmentIndex); 0 is male, 1 is female
    queryyear = @"2010";//seed the default popup button with a value
    _yearselected.text = [NSString stringWithFormat:@"Top 15 names for %@", queryyear];
    [self datesList]; // this will populate the popup button values
    [self popularlist];
   
   // [self popularlist];
   // [datetable reloadData];
}

-(NSMutableArray *) datesList {
    datesarray = [[NSMutableArray alloc] initWithCapacity:10];
    defaults = [NSUserDefaults standardUserDefaults];
    countrypref = [defaults stringForKey:@"country_preference"];
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
        querystring= [NSString stringWithFormat:@"SELECT DISTINCT year from usa order by year desc"];
        
    }
    if ([countrypref isEqualToString:@"Canada"])
    {
       // NSLog( @"Pref: %@",countrypref);
        querystring= [NSString stringWithFormat:@"SELECT DISTINCT year from canada order by year desc"];
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
    queryyear =  yearselect;
    _yearselected.text = [NSString stringWithFormat:@"Top 15 names for %@", yearselect]; //seed the default popup button with a value

    [self popularlist];
    [datetable reloadData];
}

- (IBAction)hide40picker:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    yearlistcontainer.frame = CGRectMake(0, 550, 320, 224);
    [UIView commitAnimations];
    changeyearbtn.hidden = NO;
}
- (IBAction)changeyear:(id)sender {
    //hide change year button
    changeyearbtn.hidden = YES;
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
    [self popularlist];
    [datetable reloadData];

}



-(NSMutableArray *) popularlist{
    
    babynames = [[NSMutableArray alloc] initWithCapacity:10];
    // Create a FileManager object, we will use this to check the status of the database and to copy it over if required
	NSString *databaseName;
	NSString *databasePath;
    BOOL success = 0;
    databaseName = @"brandnames.sqlite";
    defaults = [NSUserDefaults standardUserDefaults];
    countrypref = [defaults stringForKey:@"country_preference"];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
  	// If the database already exists then don't do anything
	if(success) {// nothing to be done because....//NSLog(@"Database already exists");
    }
    else
    {// If not then proceed to copy the database from the application to the users filesystem
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    };
    // [self getyearsfromdb];
    
    // NSLog(@"User: %@",databasePath);
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    [database open];
    FMResultSet *results;
    NSString *querystring;
     //NSLog(@"Value is %i", sex.selectedSegmentIndex); 0 is male, 1 is female
    //long theUnits = [defaults integerForKey:@"countrysetting"];
    if ( [countrypref isEqualToString:@"United States"] )//usa
    {
        if (sex.selectedSegmentIndex == 0) { //male
            querystring = [NSString stringWithFormat:@"SELECT firstname, sum(count) FROM usa where year = '%@' and sex = 'M' GROUP BY firstname order by sum(count) desc", queryyear];
             NSLog(@"Selected sex: %@", querystring);
            
        }
        if (sex.selectedSegmentIndex == 1) { //female
            querystring = [NSString stringWithFormat:@"SELECT firstname, sum(count) FROM usa where year ='%@' and sex = 'F' GROUP BY firstname order by sum(count) desc", queryyear];
        }
        
    }
    if ( [countrypref isEqualToString:@"Canada"]){ //canada
       
        if (sex.selectedSegmentIndex == 0) {
             
            querystring = [NSString stringWithFormat:@"SELECT firstname, sum(count) FROM canada where year ='%@' and sex = 'M' GROUP BY firstname order by sum(count) desc", queryyear];
        //NSLog(@"Selected sex: %@", querystring);
        }
        if (sex.selectedSegmentIndex == 1) {
            querystring = [NSString stringWithFormat:@"SELECT firstname, sum(count) FROM canada where year ='%@' and sex = 'F' GROUP BY firstname order by sum(count) desc", queryyear];
        }
        
    }
    
    results = [database executeQuery:querystring];
    
    while([results next]) {
        babyname * babyn = [[babyname alloc] init];
        //NSString *name = [results stringForColumn:@"name"];
        babyn.firstname = [results stringForColumn:@"firstname"];
        // babyn.sex = @"male";
        babyn.frequency = [results intForColumn:@"sum(count)"];
        // babyn.year = [results intForColumn:@"year"];
        [babynames addObject:babyn];
        //     onlyloop ++;
        //   if (onlyloop == 11) break;
    }
    [database close];
    // NSLog (@"Rows up: %i", [babynames count]);
    return babynames;
    
    
}



-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    // NSLog(@"%d",[[notification object] selectedRow]);
    // babyname* dataEntry = [babynames objectAtIndex:[[notification object] selectedRow]];
    //displayname = dataEntry.firstname;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section //this is the total number of names
    {
        
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            //4 inch screen
            return 15;
            
        }
        else{
            //3.5 inch screen
            return 15;
        }
        
        
    }

/*

- (id)tableView:datetable objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)row {
    babyname* dataEntry = [babynames objectAtIndex:row];
    if([[aTableColumn identifier] isEqual:@"col1"])
    {
        //    NSLog(@"name: %@ column: %@ row: %i", dataEntry.firstname, [aTableColumn identifier], row);
        return dataEntry.firstname;
    }
    
 
 
 /*if([[aTableColumn identifier] isEqual:@"col2"])
     {
     // NSLog(@"name: %@ column: %@ row: %i", dataEntry.firstname, [aTableColumn identifier], row);
     NSNumberFormatter *yearformatter = [[NSNumberFormatter alloc] init];
     [yearformatter setNumberStyle:NSNumberFormatterNoStyle];
     NSString *formattedOutput = [yearformatter stringFromNumber:[NSNumber numberWithInt:dataEntry.year]];
     //NSLog(@"System free space: %@", formattedOutput);
     return formattedOutput;
     }*/
/*

if([[aTableColumn identifier] isEqual:@"col2"])
    {
        // NSLog(@"name: %@ column: %@ row: %i", dataEntry.firstname, [aTableColumn identifier], row);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterNoStyle];
        NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithInt:dataEntry.frequency]];
        return formattedOutput;
    }
    
    if([[aTableColumn identifier] isEqual:@"col3"])
    {
        long myrow = row +1;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterNoStyle];
        NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithInt:myrow]];
        return formattedOutput;
    }
    
    return @"nadda";
}
*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"popularcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];}
    cell.textLabel.textColor = [UIColor whiteColor];
    
   // babyname * babyn = [[babyname alloc] init];
    babyname* babyn = [babynames objectAtIndex:indexPath.row];
  //  NSLog(@"Indexpath %i", indexPath);
    NSString *fname = [NSString stringWithFormat:@"%@", babyn.firstname];
    cell.textLabel.text = fname;
    
    //cell.detailTextLabel.text = earner.lastname;
    //cell.textLabel.text = [browsemenu objectAtIndex:indexPath.row];  //from original array
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor whiteColor];
    cell.accessoryView =accessory;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0 green:0.188235 blue:0.313725 alpha:1];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //once i got the right row selected, then move over to the new view
    /*
     if (indexPath.row == 0) {
     NSLog(@"Row Selected = %i",indexPath.row);
     //[self performSegueWithIdentifier:@"ShowEarnerDetails" sender:self];
     }
     if (indexPath.row ==1 ) {
     NSLog(@"Row Selected = %i",indexPath.row);
     //
     //[self performSegueWithIdentifier:@"search" sender:self];
     }
     if (indexPath.row ==2 ) {
     //[self performSegueWithIdentifier:@"support" sender:self];
     }
     */
}



- (void)viewDidUnload {
    sex = nil;
    [self setYearlistcontainer:nil];
    yearlist = nil;
    [self setYearselected:nil];
    changeyearbtn = nil;
    [super viewDidUnload];
}
@end
