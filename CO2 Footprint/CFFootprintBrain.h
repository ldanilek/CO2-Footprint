//
//  CFFootprintBrain.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFActivity.h"

#define FOOTPRINT_CHANGED_NOTIFICATION @"Note: the footprint has now changed. Store it now."

@interface CFFootprintBrain : NSObject <NSCoding>

//initializing from NSKeyedUnarchiver is encouraged, when possible
//otherwise, create a blank (no activities) footprint with the designated initializer init
- (double)footprint;//in tons of carbon per week
@property (strong, nonatomic) NSArray *activities;

//sorted by footprint
- (ActivityType)activityTypeAtIndex:(int)index;
- (double)footprintForType:(ActivityType)activityType;

- (NSUInteger)activityCountOfType:(ActivityType)activityType;
- (CFActivity *)activityAtIndex:(int)index withType:(ActivityType)activityType;
- (NSString *)activityDisplayAtIndex:(int)index forType:(ActivityType)activityType;
- (void)deleteActivityAtIndex:(int)index withType:(ActivityType)activityType;

- (CFActivity *)newActivityWithType:(ActivityType)activityType;//adds activity to carbon footprint and returns it for further editing

@end
