//
//  graph.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-04.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "graph.h"
#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "names.h"
#import "FMDatabase.h"
#import "FMResultSet.h"


@interface graph ()

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;



@end



@implementation graph {
    
    NSMutableArray *babynames;
    NSString* countrypref;
    NSUserDefaults *defaults;
    
}

@synthesize name;
@synthesize sexflag;
@synthesize hostView;

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
    label.text = [NSString stringWithFormat:@"%@", name];
    [label sizeToFit];

    [self loaddatabase];
    [self showgraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showgraph {
    //get the results for all that equal displayname
    
    int theMax;  // how high up should the graph go
    BOOL firstTime = YES;
    for(babyname *object in babynames) {
        if(firstTime) {
            theMax = object.frequency;
            firstTime = NO;
            continue;
        }
        theMax = fmax(theMax, object.frequency );
    }
    int thexMin; // what year to start the graph?
    int thexMax;
    BOOL firstxTime = YES;
    for(babyname *objectx in babynames) {
        if(firstxTime) {
            thexMin =  thexMax = objectx.year;
            firstxTime = NO;
            continue;
        }
        thexMin = fmin(thexMin, objectx.year );
        thexMax = fmax(thexMax, objectx.year );
    }
    
    mygraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [mygraph applyTheme:theme];
    
    hostView = (CPTGraphHostingView*)self.view;  //new
    hostView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostView.hostedGraph     = mygraph;
    
    // Graph title
    //mygraph.title = [NSString stringWithFormat:@"Baby Name: %@", name];
    //CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    CPTColor *areaColor;
    CPTColor *endingColor;
    if (sexflag == 0) { //male colors
        areaColor = [CPTColor colorWithComponentRed:0.4  green:0.8 blue:1.0 alpha:1.0];
        endingColor = [CPTColor colorWithComponentRed:0.8 green:1.0 blue:1.0 alpha:0.2]; }
    if (sexflag==1) { //female colors
        areaColor = [CPTColor colorWithComponentRed:1.0 green:0.227 blue:0.624 alpha:1.0];
        endingColor = [CPTColor colorWithComponentRed:1.0 green:0.227 blue:0.624 alpha:0.0];}
    //textStyle.color  = areaColor;
    //textStyle.fontName             = @"Helvetica-Bold";
    //textStyle.fontSize             = 16.0;
    //textStyle.textAlignment        = CPTTextAlignmentCenter;
    //mygraph.titleTextStyle           = textStyle;
    //mygraph.titleDisplacement        = CGPointMake(0.0, 20.0);
    
    // Graph padding
    mygraph.paddingLeft   = 35.0;
    mygraph.paddingTop    = 5.0;
    mygraph.paddingRight  = 15.0;
    mygraph.paddingBottom = 25.0;
 /*
    mygraph.paddingBottom = 30.0f;
    mygraph.paddingLeft  = 30.0f;
    mygraph.paddingTop    = -1.0f;
    mygraph.paddingRight  = -5.0f;
    */
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)mygraph.defaultPlotSpace;
    plotSpace.delegate = self;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInteger(thexMin)
                                                    length:CPTDecimalFromInteger(thexMax - thexMin)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInteger(0)
                                                    length:CPTDecimalFromInteger(theMax+5)];
    
    // X-axis parameters setting
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    mygraph.plotAreaFrame.masksToBorder = NO;
    CPTXYAxisSet *xyAxisSet = (CPTXYAxisSet *)mygraph.axisSet;
    CPTXYAxis *xAxis = xyAxisSet.xAxis;
    CPTXYAxis *yAxis = xyAxisSet.yAxis;
    
    NSNumberFormatter *XYformatter = [[NSNumberFormatter alloc] init];
    [XYformatter setGeneratesDecimalNumbers:NO];
    [XYformatter setNumberStyle:NSNumberFormatterNoStyle];
    xAxis.labelFormatter = XYformatter;
    yAxis.labelFormatter = XYformatter;
    lineStyle.lineCap = kCGLineCapButt;
    xAxis.axisLineStyle = lineStyle;
    xAxis.majorTickLength = 10;
    xAxis.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
    xAxis.labelOffset = 0;
    xAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    xyAxisSet.delegate = self;
    xAxis.delegate = self;
    yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    yAxis.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
    yAxis.minorTicksPerInterval       = 2;
    yAxis.preferredNumberOfMajorTicks = 10;
    
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor grayColor] colorWithAlphaComponent:0.1];
    yAxis.majorGridLineStyle          = majorGridLineStyle;
    yAxis.minorGridLineStyle          = minorGridLineStyle;
    yAxis.axisLineStyle = lineStyle;
    yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    yAxis.delegate = self;
    
    CPTScatterPlot *boundLinePlot = [[CPTScatterPlot alloc] init];
    boundLinePlot.identifier =@"AllNames";
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.dataSource = self;
    [mygraph addPlot:boundLinePlot];
    
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor
                                                            endingColor:endingColor]; //[CPTColor clearColor]];
    areaGradient.angle = -90.0f;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    boundLinePlot.areaFill = areaGradientFill;
    boundLinePlot.areaBaseValue = CPTDecimalFromString(@"1.75");
    
    
}


 -(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    int babycount = (int)[babynames count];
    //NSLog(@"Records: %i",babycount);
    return babycount;
    
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot
                     field:(NSUInteger)fieldEnum
               recordIndex:(NSUInteger)index
{
    babyname* dataEntry = [babynames objectAtIndex:index];
    
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX:
        {
            NSNumber *num = [dataEntry valueForKey:@"year"];
          //    NSLog (@"Number year: %@", num);
            return num;
        }
        case CPTScatterPlotFieldY:
        {
            NSNumber *num = [dataEntry valueForKey:@"frequency"];
       //        NSLog (@"Number freq: %@", num);
            return num;
        }
    }
    return nil;
}


-(NSMutableArray *) loaddatabase{
    
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
    
    if ( [countrypref isEqualToString:@"United States"] )//usa
    {
        if (sexflag == 0) { //male
            querystring = [NSString stringWithFormat:@"SELECT * from usa where firstname = '%@' and sex = 'M' order by firstname, year", name];
            
        }
        if (sexflag == 1) { //female
            querystring = [NSString stringWithFormat:@"SELECT * from usa where firstname = '%@' and sex = 'F' order by firstname, year", name];        }
        
    }
    if ( [countrypref isEqualToString:@"Canada"]){ //canada
        
        if (sexflag == 0) {
            
            querystring = [NSString stringWithFormat:@"SELECT * from canada where firstname = '%@' and sex = 'M' order by firstname, year", name];
            //NSLog(@"Selected sex: %@", querystring);
        }
        if (sexflag == 1) {
            querystring = [NSString stringWithFormat:@"SELECT * from canada where firstname = '%@' and sex = 'F' order by firstname, year", name];
        }
        
    }
    
    results = [database executeQuery:querystring];
    
    while([results next]) {
        babyname * babyn = [[babyname alloc] init];
        babyn.firstname = [results stringForColumn:@"firstname"];
        babyn.frequency = [results intForColumn:@"count"];
        babyn.year = [results intForColumn:@"year"];
        [babynames addObject:babyn];
        
    }
    [database close];
   // NSLog (@"Rows up: %i", [babynames count]);
    return babynames;
    
    
}


@end
