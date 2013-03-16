//
//  unisex.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-10.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "unisex.h"
#import "names.h"
#import "unisexCell.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#define kUnisexCellIdentifier @"UnisexCellIdentifier"

@interface unisex ()


@end

@implementation unisex {
    
    NSMutableArray *babynames;
    NSUserDefaults *defaults;
    NSString* countrypref;
}

@synthesize unisextable;


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
    [self.unisextable registerNib:[UINib nibWithNibName:@"unisex" bundle:nil] forCellReuseIdentifier:kUnisexCellIdentifier]; //setup my customcell
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.243 green:0.125 blue:0.345 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:24.0];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"-Unisex Names-", @"");
    [label sizeToFit];
    [self pbabyList];  //get unixsex names from plist vs sql
     //[self babyList];  //get unixsex names from sql table (takes too long to load)
    [unisextable reloadData]; //load the table
   
}

-(NSMutableArray *) pbabyList{
    babynames = [[NSMutableArray alloc] initWithCapacity:10];
    //NSArray *plistbabynames = [[NSMutableArray alloc] initWithCapacity:10];
    defaults = [NSUserDefaults standardUserDefaults];
    countrypref = [defaults stringForKey:@"country_preference"];
    NSString *myListPath;
    
    if ( [countrypref isEqualToString:@"United States"] )//usa
    {
       myListPath = [[NSBundle mainBundle] pathForResource:@"unisexusa" ofType:@"plist"];
    }
    if ( [countrypref isEqualToString:@"Canada"]) //canada
    {
       myListPath = [[NSBundle mainBundle] pathForResource:@"unisexcanada" ofType:@"plist"];
    }
    NSArray *plistbabynames = [[NSArray alloc]initWithContentsOfFile:myListPath];
    NSSortDescriptor* nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES];
    plistbabynames = [plistbabynames sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSortDescriptor]];
    babynames = [NSMutableArray arrayWithArray:plistbabynames];
    return babynames;
    
    
}

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
	if(success) {  //do nothing
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
    if ( [countrypref isEqualToString:@"United States"] )//usa
    {
        querystring = [NSString stringWithFormat:@"SELECT firstname, SUM(CASE WHEN sex = 'M' THEN count END) as mcount, SUM(CASE WHEN sex = 'F' THEN count END) as fcount FROM usa GROUP BY firstname"];
    }
    if ( [countrypref isEqualToString:@"Canada"]) //canada
        {
        querystring = [NSString stringWithFormat:@"SELECT firstname, SUM(CASE WHEN sex = 'M' THEN count END) as mcount, SUM(CASE WHEN sex = 'F' THEN count END) as fcount FROM canada GROUP BY firstname"];
    }
    results = [database executeQuery:querystring];
    while([results next]) {
        babyname * babyn = [[babyname alloc] init];
        babyn.firstname = [results stringForColumn:@"firstname"];
        babyn.malecount = [results intForColumn:@"mcount"];
        babyn.femalecount = [results intForColumn:@"fcount"];
        if ([results intForColumn:@"mcount"] == 0 || [results intForColumn:@"fcount"] ==0 )
        {
            //don't add the result
        }
        else
        {
            [babynames addObject:babyn];
        }
        
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
    return @"Name     # of Male  # of Female";
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

/*   --------- this is old tableview before I used a plist file -----------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = kUnisexCellIdentifier;
    unisexCell *nameCell = (unisexCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    babyname* babyn = [babynames objectAtIndex:indexPath.row];
    nameCell.cellname.text =  babyn.firstname;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
 */   
    /*  ---not needed shading
     if (babyn.malecount == babyn.femalecount) {
        // shade both cells green
        nameCell.cellfemale.backgroundColor = [UIColor greenColor];
        nameCell.cellmale.backgroundColor = [UIColor greenColor];
    }
    if (babyn.malecount < babyn.femalecount) {
        // shade female cell pink
        nameCell.cellfemale.backgroundColor = [UIColor redColor];
    }
    if (babyn.malecount > babyn.femalecount) {
        // shade male cell blue
        nameCell.cellmale.backgroundColor = [UIColor blueColor];
    }
    *///----need the next 4 lines

/*
    NSString *maleOutput = [formatter stringFromNumber:[NSNumber numberWithInt:babyn.malecount]];
    NSString *femaleOutput = [formatter stringFromNumber:[NSNumber numberWithInt:babyn.femalecount]];
    nameCell.cellmale.text = maleOutput;
    nameCell.cellfemale.text = femaleOutput;
   */

/* ---not needed shading 

 UIImage *image = [UIImage imageNamed:@"background2.jpg"];
    CGFloat y = indexPath.row * 35;
    for (y; y+35 > image.size.height; y -= image.size.height);
    CGRect cropRect = CGRectMake(0, y, 320, 35);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    nameCell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageRef]];
    */

 //   return nameCell;
    
//}
//   --------- END this is old tableview before I used a plist file -----------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = kUnisexCellIdentifier;
    unisexCell *nameCell = (unisexCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *user = [babynames objectAtIndex:indexPath.row];
    NSString *fname = [user objectForKey:@"firstname"];
    NSString *mcount = [user objectForKey:@"mcount"];
    NSString *fcount = [user objectForKey:@"fcount"];

    nameCell.cellname.text =  fname;
    nameCell.cellmale.text = mcount;
    nameCell.cellfemale.text = fcount;
    
    return nameCell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUnisextable:nil];
    [super viewDidUnload];
}
@end
