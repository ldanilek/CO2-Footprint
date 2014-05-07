//
//  CFActivity.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFActivity.h"

@implementation CFActivity

//the entire goal of this object is to be able to calculate the footprint of an activity
//this method is very important
//returns tons of carbon per week per person
- (double)footprint {
    double carbon;//this number will be divided by the sharing count
    if (self.type==ActivityTransportation) {
        //efficiency is miles/gallon
        //usage is miles
        double gallons = self.usage/self.efficiency;
        //depending on type of vehicle (self.subtype), each gallon will have different amounts of carbon.
#warning LOOK_UP_FOOTPRINT_OF_FUELS
        //currently just dummy values
        double carbonPerGallon = 1;
        switch (self.subtype) {
            case TransportationCar:
                carbonPerGallon=10;
                break;
            case TransportationPlane:
                carbonPerGallon=100;
                break;
            case TransportationTruck:
                carbonPerGallon=20;
                break;
            case TransportationBus:
                carbonPerGallon=15;
                break;
        }
        carbon = gallons*carbonPerGallon;
    } else {
        //assume electricity for now
        //efficiency is hours per joule used
        //usage is hours used
        double joules = self.usage/self.efficiency;
#warning LOOK_UP_FOOTPRINT_OF_ELECTRICITY
        double carbonPerJoule = 1;
        carbon = joules*carbonPerJoule;
    }
    return carbon/self.sharingCount;
}

#pragma mark - STORAGE

//keys for storing attributes
#define ACTIVITY_TYPE @"activity type"
#define SUBTYPE @"activity subtype"
#define TITLE @"activity title"
#define BRAND @"activity brand"
#define MODEL @"activity model"
#define SHARING_COUNT @"activity sharing"
#define EFFICIENCY @"activity efficiency"
#define USAGE @"activity usage"

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.type forKey:ACTIVITY_TYPE];
    [aCoder encodeInteger:self.subtype forKey:SUBTYPE];
    [aCoder encodeObject:self.title forKey:TITLE];
    [aCoder encodeObject:self.brand forKey:BRAND];
    [aCoder encodeObject:self.model forKey:MODEL];
    [aCoder encodeDouble:self.sharingCount forKey:SHARING_COUNT];
    [aCoder encodeDouble:self.efficiency forKey:EFFICIENCY];
    [aCoder encodeDouble:self.usage forKey:USAGE];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self=[self initWithType:[aDecoder decodeIntegerForKey:ACTIVITY_TYPE]]) {
        self.subtype=[aDecoder decodeIntegerForKey:SUBTYPE];
        self.title=[aDecoder decodeObjectForKey:TITLE];
        self.brand=[aDecoder decodeObjectForKey:BRAND];
        self.model=[aDecoder decodeObjectForKey:MODEL];
        self.sharingCount=[aDecoder decodeDoubleForKey:SHARING_COUNT];
        self.efficiency=[aDecoder decodeDoubleForKey:EFFICIENCY];
        self.usage=[aDecoder decodeDoubleForKey:USAGE];
    }
    return self;
}

//designated initializer. must set type and not change it, so activity knows how to interpret its other attributes
- (instancetype)initWithType:(ActivityType)activityType {
    if (self=[super init]) {
        _type=activityType;
    }
    return self;
}

- (instancetype)init {
    [NSException raise:@"init not available" format:@"The initializer init is unavailable for CFActivity, as it must be initialized with a type"];
    return nil;
}

@end
