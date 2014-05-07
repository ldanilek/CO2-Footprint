//
//  CFFootprintBrain.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFActivity.h"

@interface CFFootprintBrain : NSObject <NSCoding>

//initializing from NSKeyedUnarchiver is encouraged, when possible
//otherwise, create a blank (no activities) footprint with the designated initializer init
- (double)footprint;//in tons of carbon per week
@property (strong, nonatomic) NSArray *activities;

- (CFActivity *)newActivityWithType:(ActivityType)activityType;//adds activity to carbon footprint and returns it for further editing

@end
