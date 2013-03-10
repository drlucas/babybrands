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
#import "namecellCell.h"
#import "graph.h"
#define kNameCellIdentifier @"NameCellIdentifier"


@interface popularnames ()
- (IBAction)changesex:(id)sender;


@end

@implementation popularnames {
    
    IBOutlet UIPickerView *yearlist;
    IBOutlet UISegmentedControl *sex;
    IBOutlet UIButton *changeyearbtn;
    IBOutlet UILabel *changeyeartext;
    IBOutlet UILabel *switchgendertext;
    
    
    NSInteger pickerrow;
    NSString *yearselect;
    NSMutableArray *babynames;   //array to store male and female top 10 in each year
    NSUserDefaults *defaults;
    NSString* countrypref;
    NSString *queryyear;
    UILabel *label;
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
    //not needed - not changing button anymore -- changeyearbtn.titleLabel. numberOfLines = 0; // Dynamic number of lines
    // changeyearbtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    // Change the tintColor of each subview within the array:

    [super viewDidLoad];
    [self.datetable registerNib:[UINib nibWithNibName:@"namecell" bundle:nil] forCellReuseIdentifier:kNameCellIdentifier]; //setup my customcell
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.243 green:0.125 blue:0.345 alpha:1];
    queryyear = @"2010";//seed the default popup button with a value
        [self titlebarupdate]; 
    [self datesList]; // this will populate the popup button values
    [self popularlist];
   
}

-(void) titlebarupdate {
    label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15.0];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = [NSString stringWithFormat:@"Top 15 Names for %@", queryyear];
    [label sizeToFit];
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
    //label = [NSString stringWithFormat:@"Top 15 Names for %@", yearselect]; //seed the default popup button with a value
    [self popularlist];
    [datetable reloadData];
    [self titlebarupdate];
}

- (IBAction)hide40picker:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    yearlistcontainer.frame = CGRectMake(0, 550, 320, 224);
    
    changeyearbtn.hidden = NO;
    changeyeartext.hidden = NO;
    switchgendertext.hidden = NO;
    [UIView commitAnimations];
}
- (IBAction)changeyear:(id)sender {
    //hide change year button
    changeyearbtn.hidden = YES;
    changeyeartext.hidden = YES;
    switchgendertext.hidden = YES;
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
    /*NSArray *arri = [sex subviews];
    [[arri objectAtIndex:0] setTintColor:[UIColor colorWithRed:1.0f green:0.0f  blue:0.5f  alpha:1.0f]];
    [[arri objectAtIndex:1] setTintColor:[UIColor colorWithRed:0.0f green:0.0f  blue:1.0f  alpha:1.0f]];
    sex.segmentedControlStyle = UISegmentedControlStyleBar;*/
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
           //  NSLog(@"Selected sex: %@", querystring);
            
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = kNameCellIdentifier;
    namecellCell *nameCell = (namecellCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    babyname* babyn = [babynames objectAtIndex:indexPath.row];
    NSString *icon1name;
    NSString *icon2name;
    NSString *icon3name;
    if (indexPath.row ==0) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==1) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==2) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==3) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==4) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==5) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==6) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==7) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==8) {
        icon3name = [NSString stringWithFormat:@"animal_number_%i.png",(indexPath.row+1)];
        icon2name = nil;
        icon1name = nil;}
    else if (indexPath.row ==9) {
        icon3name = nil;
        icon1name = [NSString stringWithFormat:@"animal_number_1.png"];
        icon2name = [NSString stringWithFormat:@"animal_number_0.png"];}
    else if (indexPath.row ==10) {
        icon3name = nil;
        icon1name = [NSString stringWithFormat:@"animal_number_1.png"];
        icon2name = [NSString stringWithFormat:@"animal_number_1.png"];}
    else if (indexPath.row ==11) {
        icon3name = nil;
        icon1name = [NSString stringWithFormat:@"animal_number_1.png"];
        icon2name = [NSString stringWithFormat:@"animal_number_2.png"];}
    else if (indexPath.row ==12) {
        icon3name = nil;
        icon1name = [NSString stringWithFormat:@"animal_number_1.png"];
        icon2name = [NSString stringWithFormat:@"animal_number_3.png"];}
    else if (indexPath.row ==13) {
        icon3name = nil;
        icon1name = [NSString stringWithFormat:@"animal_number_1.png"];
        icon2name = [NSString stringWithFormat:@"animal_number_4.png"];}
    else   {
        icon3name = nil;
        icon1name = [NSString stringWithFormat:@"animal_number_1.png"];
        icon2name = [NSString stringWithFormat:@"animal_number_5.png"];
    };
    nameCell.icon3View.image = [UIImage imageNamed:icon3name];
    nameCell.icon2View.image = [UIImage imageNamed:icon2name];
    nameCell.icon1View.image = [UIImage imageNamed:icon1name];
    nameCell.cellName.text =  babyn.firstname;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithInt:babyn.frequency]];
    nameCell.cellCount.text = formattedOutput;
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:nameCell.textLabel.textColor];
    accessory.highlightedColor = [UIColor blueColor];
    nameCell.accessoryView =accessory;
    return nameCell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Rank      Name            Total Births";
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
   // babyname* babyn = [babynames objectAtIndex:indexPath.row];
   // NSString *name = [NSString stringWithFormat:@"%@",  babyn.firstname];
   // NSLog (@"Name: %@",name);
    [self performSegueWithIdentifier:@"movetograph" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"movetograph"]) {
       // NSLog(@"identifier: %@",segue.identifier);
        NSIndexPath *indexPath = [self.datetable indexPathForSelectedRow];
        babyname* babyn = [babynames objectAtIndex:indexPath.row];
        NSString *name = [NSString stringWithFormat:@"%@",  babyn.firstname];
       // NSLog (@"Name: %@",name);
        graph *destViewController = segue.destinationViewController;
        destViewController.name = name;
        destViewController.sexflag = sex.selectedSegmentIndex;
        }
}



- (void)viewDidUnload {
    sex = nil;
    [self setYearlistcontainer:nil];
    yearlist = nil;
    //[self setYearselected:nil];
    changeyearbtn = nil;
    changeyeartext = nil;
    switchgendertext = nil;
    [super viewDidUnload];
}
@end
