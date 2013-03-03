//
//  DTCustomColoredAccessory.h
//  test-view
//
//  Created by Ryan Lucas on 2013-01-03.
//  Copyright (c) 2013 Ryan Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DTCustomColoredAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color;

@end