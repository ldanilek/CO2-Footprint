//
//  CFUnit.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/18/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSUInteger doubleHash(double value) {
    return *(NSUInteger *)&value;
}

//if both are nil, isEqual: will return NO. It shouldn't.
static BOOL equalObjs(id obj1, id obj2) {
    return obj1==obj2 || [obj1 isEqual:obj2];
}

typedef enum {
    Unitless,
    UnitDistance,//mi
    UnitEnergy,//J
    UnitMass,//ton
    UnitTime,//wk
    UnitVolume,//gal
    UnitMoney,//$
} CFUnitType;

//stores a number with units

@interface CFValue : NSObject <NSCoding, NSCopying>

//designated initializer
- (instancetype)initWithUnitsTop:(CFUnitType)typeTop bottom:(CFUnitType)typeBottom;//sets units to base units

@property (nonatomic) double valueInCurrentUnits;//not stored. use for setting and getting
@property (nonatomic) double value;//stored in base units
@property (atomic, readonly) CFUnitType topUnitType;
@property (atomic, readonly) CFUnitType bottomUnitType;
@property (nonatomic) NSString *topUnit;
@property (nonatomic) NSString *bottomUnit;

+ (NSArray *)possibleUnitsForType:(CFUnitType)unitType;
+ (NSArray *)possibleUnitsOfSameType:(NSString *)unit index:(int *)indexRetVal;

@end


/*
This is how to do a hash
 - (NSUInteger)hash {
 NSUInteger prime = 31;
 NSUInteger result= 1;
 result+=prime*result + self.brand.hash;
 result+=prime*result + self.model.hash;
 result+=prime*result + self.title.hash;
 result+=prime*result + doubleHash(self.efficiency);
 result+=prime*result + doubleHash(self.usage);
 result+=prime*result + doubleHash(self.sharingCount);
 result+=prime*result + self.subtype;
 result+=prime*result + self.type;
 return result;
 }
*/