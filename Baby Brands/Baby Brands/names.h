//
//  names.h
//  babynames
//
//  Created by Ryan Lucas on 2013-01-19.
//  Copyright (c) 2013 watchthebirdies.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface babyname : NSObject {
    NSString *firstname;
    int year;
    int frequency;
    int malecount; //for unisex only
    int femalecount;//for unisex only
}

@property (copy) NSString *firstname;
@property  int year;
@property int frequency;
@property int malecount; //for unisex only
@property int femalecount; //for unisex only
@end
