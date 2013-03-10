//
//  namecellCell.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-09.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "namecellCell.h"

@implementation namecellCell


@synthesize icon1View = _icon1View;
@synthesize icon2View = _icon2View;
@synthesize icon3View = _icon3View;
@synthesize cellName = _cellName;
@synthesize cellCount = _cellCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
   // NSLog(@"do i get here?");
    // Configure the view for the selected state
}

@end
