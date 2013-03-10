//
//  graph.h
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-04.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "names.h"
#import "FMDatabase.h"
#import "FMResultSet.h"


@interface graph : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate, UIActionSheetDelegate>
{
    CPTXYGraph *mygraph;
}

@property (nonatomic, strong) NSString *name;
@property (assign) int sexflag;

@end
