//
//  drawline.m
//  Baby Brands
//
//  Created by Ryan Lucas on 2013-03-12.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import "drawline.h"

@implementation drawline

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)drawRect:(CGRect)rect {
    int xStart = 10, yStart = 10;
    int gridSize = 300;
    
    UIBezierPath *topPath = [UIBezierPath bezierPath];
    // draw vertical lines
    for(int xId=1; xId<=2; xId++) {
        int x = xStart + xId * gridSize / 3;
        [topPath moveToPoint:CGPointMake(x, yStart)];
        [topPath addLineToPoint:CGPointMake(x, yStart+gridSize)];
    }
    
    // draw horizontal lines
    for(int yId=1; yId<=2; yId++) {
        int y = yStart + yId * gridSize / 3;
        [topPath moveToPoint:CGPointMake(xStart, y)];
        [topPath addLineToPoint:CGPointMake(xStart+gridSize, y)];
    }
    
    [[UIColor whiteColor] setStroke];
    
    [topPath stroke];
}
*/

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx,[UIColor whiteColor].CGColor);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
}

@end
