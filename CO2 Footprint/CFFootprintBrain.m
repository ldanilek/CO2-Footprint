//
//  CFFootprintBrain.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFFootprintBrain.h"

@implementation CFFootprintBrain

- (double)footprintForType:(ActivityType)activityType {
    double footprint = 0;
    for (CFActivity *activity in self.activities) {
        if (activity.type==activityType) {
            footprint+=activity.footprint;
        }
    }
    return footprint;
}

- (ActivityType)activityTypeAtIndex:(int)index {
    NSMutableArray *types = [NSMutableArray array];
    for (ActivityType i=0; i<typeCount(); i++) {
        [types addObject:@(i)];
    }
    [types sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        double diff = [self footprintForType:[obj2 intValue]]-[self footprintForType:[obj1 intValue]];
        if (diff>0) return NSOrderedDescending;
        if (diff<0) return NSOrderedAscending;
        return NSOrderedSame;
    }];
    return [types[index] intValue];
}

- (void)deleteActivityAtIndex:(int)index withType:(ActivityType)activityType {
    int indexToDelete=self.activities.count;
    NSUInteger count = 0;
    int indexChecking = 0;
    for (CFActivity *activity in self.activities) {
        if (activity.type==activityType) {
            if (count==index) indexToDelete = indexChecking;
            count++;
        }
        indexChecking++;
    }
    NSArray *before = [self.activities subarrayWithRange:NSMakeRange(0, indexToDelete)];
    NSArray *after = [self.activities subarrayWithRange:NSMakeRange(indexToDelete+1, self.activities.count-indexToDelete-1)];
    self.activities=[before arrayByAddingObjectsFromArray:after];
}

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

static int sign(double x) {
    if (x>0) return 1;
    if (x<0) return -1;
    return 0;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[self init]) {
        self.activities=[aDecoder decodeObjectForKey:ACTIVITIES_KEY];
        self.activities=[self.activities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return sign([obj2 footprint]-[obj1 footprint]);
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.activities forKey:ACTIVITIES_KEY];
}

@end
