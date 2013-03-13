//
//  search.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-02.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "search.h"
#import "names.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "graph.h" 
#import "searchcellCell.h"
#import "DTCustomColoredAccessory.h"
#define kSearchCellIdentifier @"SearchCellIdentifier"

@interface search ()

@end

@implementation search {
    
    IBOutlet UITextField *name; //the name that the user entered to search for

    IBOutlet UILabel *resultstext;
    IBOutlet UISegmentedControl *sex;
    NSMutableArray *babynames;
    NSUserDefaults *defaults;
    NSString* countrypref;
    
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
    [self.searchtable registerNib:[UINib nibWithNibName:@"searchcell" bundle:nil] forCellReuseIdentifier:kSearchCellIdentifier]; //setup my customcell
    searchtable.hidden = YES; //hide table until search results are known
    
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.243 green:0.125 blue:0.345 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:30.0];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Search", @"");
    [label sizeToFit];

    
    
}

@synthesize searchtable;

/*{
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}
*/

-(NSMutableArray *) babyList{
    babynames = [[NSMutableArray alloc] initWithCapacity:10];
    defaults = [NSUserDefaults standardUserDefaults];
    countrypref = [defaults stringForKey:@"country_preference"];
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
    // [self getyearsfromdb];
    
    //NSLog(@"User: %@",databasePath);
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    FMResultSet *results;
    NSString *myString = name.text;
    NSString *querystring;
    if ( [countrypref isEqualToString:@"United States"] )//usa
    {
        if (sex.selectedSegmentIndex == 0) { //male
            querystring = [NSString stringWithFormat:@"SELECT firstname, sum(count) FROM usa where firstname LIKE '%%%@%%' and sex = 'M' GROUP BY firstname order by sum(count) desc", myString];
        }
        if (sex.selectedSegmentIndex == 1) { //female
           querystring = [NSString stringWithFormat:@"SELECT firstname, sum(count) FROM usa where firstname LIKE '%%%@%%' and sex = 'F' GROUP BY firstname order by sum(count) desc", myString];
        }
        
    }
    if ( [countrypref isEqualToString:@"Canada"]){ //canada
        
        if (sex.selectedSegmentIndex == 0) {
            
            querystring = [NSString stringWithFormat:@"SELECT firstname, sum(count) FROM canada where firstname LIKE '%%%@%%' and sex = 'M' GROUP BY firstname order by sum(count) desc", myString];        }
        if (sex.selectedSegmentIndex == 1) {
            querystring = [NSString stringWithFormat:@"SELECT firstname, sum(count) FROM canada where firstname LIKE '%%%@%%' and sex = 'F' GROUP BY firstname order by sum(count) desc", myString];
        }
        
    }
    results = [database executeQuery:querystring];
   
    while([results next]) {
        babyname * babyn = [[babyname alloc] init];
        babyn.firstname = [results stringForColumn:@"firstname"];
        babyn.frequency = [results intForColumn:@"sum(count)"];
        [babynames addObject:babyn];
    }
    [database close];
    return babynames;
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
        return babynames.count;
        
    }
    else{
        //3.5 inch screen
         return babynames.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Name                       Total Births";
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
    [self performSegueWithIdentifier:@"searchgraph" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = kSearchCellIdentifier;
    searchcellCell *nameCell = (searchcellCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    /* NOTE: Add some code like this to create a new cell if there are none to reuse
    if(nameCell == nil)
    {
        nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        
    }
*/
  
    
    babyname* babyn = [babynames objectAtIndex:indexPath.row];
        
    nameCell.cellName.text =  babyn.firstname;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithInt:babyn.frequency]];
    nameCell.cellCount.text = formattedOutput;
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:nameCell.textLabel.textColor];
    accessory.highlightedColor = [UIColor blueColor];
    nameCell.accessoryView =accessory;
   
    /*UIImage *image = [UIImage imageNamed:@"background2.jpg"];
    CGFloat y = indexPath.row * 35;
    for (y; y+35 > image.size.height; y -= image.size.height);
    CGRect cropRect = CGRectMake(0, y, 320, 35);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    nameCell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageRef]];
*/
    return nameCell;
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"searchgraph"]) {
        NSIndexPath *indexPath = [self.searchtable indexPathForSelectedRow];
        babyname* babyn = [babynames objectAtIndex:indexPath.row];
        NSString *firstname = [NSString stringWithFormat:@"%@",  babyn.firstname];
        // NSLog (@"Name: %@",name);
        graph *destViewController = segue.destinationViewController;
        destViewController.name = firstname;
        destViewController.sexflag = sex.selectedSegmentIndex;
    }
}



- (IBAction)searchnames:(id)sender { //user clicked the search button
    [self babyList]; //pull up the data that the user entered
    [searchtable reloadData]; //reload the table
    if ([babynames count] == 0 ) {  //display no results
       resultstext.text = @"No names found - please search again";
        searchtable.hidden = YES;
    }
    else {
        resultstext.text = [NSString stringWithFormat:@"%i names found", [babynames count]];
        searchtable.hidden = NO;
        //searchtable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    // hide table if no records
    
}


- (IBAction)doneEditing:(id)sender {  //used to deal with keyboard dismissal
    [sender resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    name = nil;
    searchtable = nil;
    resultstext = nil;
    sex = nil;
    [self setSearchtable:nil];
    [super viewDidUnload];
}
@end
