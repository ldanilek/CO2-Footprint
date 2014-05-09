//
//  CFFootprintBrain.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFFootprintBrain.h"

@implementation CFFootprintBrain

- (NSString *)activityDisplayAtIndex:(int)index forType:(ActivityType)activityType {
    return [[self activityAtIndex:index withType:activityType] display];
}

- (CFActivity *)activityAtIndex:(int)index withType:(ActivityType)activityType {
    NSUInteger count = 0;
    for (CFActivity *activity in self.activities) {
        if (activity.type==activityType) {
            if (count==index) return activity;
            count++;
        }
    }
    return nil;
}

- (NSUInteger)activityCountOfType:(ActivityType)activityType {
    NSUInteger count = 0;
    for (CFActivity *activity in self.activities) {
        if (activity.type==activityType) count++;
    }
    return count;
}

- (CFActivity *)newActivityWithType:(ActivityType)activityType {
    CFActivity *newActivity = [[CFActivity alloc] initWithType:activityType];
    self.activities=[self.activities arrayByAddingObject:newActivity];
    return newActivity;
}

- (double)footprint {
    double footprint = 0;
    for (CFActivity *activity in self.activities) {
        footprint+=[activity footprint];
    }
    return footprint;
}

//if activities haven't been set already, create an empty array
- (NSArray *)activities {
    if (!_activities) {
        _activities=[NSArray array];
    }
    return _activities;
}

#define ACTIVITIES_KEY @"Key for storing activities"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[self init]) {
        self.activities=[aDecoder decodeObjectForKey:ACTIVITIES_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.activities forKey:ACTIVITIES_KEY];
}

@end
