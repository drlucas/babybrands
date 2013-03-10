//
//  searchcellCell.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-10.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "searchcellCell.h"

@implementation searchcellCell

@synthesize icon1View = _icon1View;
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

    // Configure the view for the selected state
}

@end
