//
//  unisexCell.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-10.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "unisexCell.h"

@implementation unisexCell

@synthesize cellname = _cellname;
@synthesize cellmale = _cellmale;
@synthesize cellfemale = _cellfemale;


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
