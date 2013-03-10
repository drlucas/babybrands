//
//  namecellCell.h
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-09.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface namecellCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *icon1View;
@property (nonatomic, strong) IBOutlet UIImageView *icon2View;
@property (nonatomic, strong) IBOutlet UIImageView *icon3View;
@property (nonatomic, strong) IBOutlet UILabel *cellName;
@property (nonatomic, strong) IBOutlet UILabel *cellCount;

@end
