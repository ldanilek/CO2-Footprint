//
//  CFUnit.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/18/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFValue.h"

@implementation CFValue

//conversion to base units
+ (double)convertFrom:(NSString *)fromTop over:(NSString *)fromBottom {
    return [self convertTo:fromBottom]/[self convertTo:fromTop];
}

//unit1 * [convertTo:baseUnit] = unit1
//baseUnit / [convertTo:unit2] = unit2
+ (double)convertTo:(NSString *)unit {
    //return coefficient of c*baseUnit/unit=1. for example, day/wk has coefficient 7
    //find by converting 1 baseUnit to unit
    if ([self.timeUnits containsObject:unit]) {
        //convert from weeks
        if ([unit isEqualToString:@"wk"]) return 1;
        if ([unit isEqualToString:@"day"]) return 7;
        if ([unit isEqualToString:@"hr"]) return 7*24;
        if ([unit isEqualToString:@"yr"]) return 0.019164956;
        if ([unit isEqualToString:@"mo"]) return 0.22999;
    } else if ([self.distanceUnits containsObject:unit]) {
        //convert from miles
        if ([unit isEqualToString:@"mi"]) return 1;
        if ([unit isEqualToString:@"km"]) return 1.609344;
    } else if ([self.energyUnits containsObject:unit]) {
        //to Joules
        if ([unit isEqualToString:@"J"]) return 1;
        if ([unit isEqualToString:@"lbft"]) return 0.73756215;
        if ([unit isEqualToString:@"Btu"]) return 0.00094781712;
        if ([unit isEqualToString:@"kWh"]) return 2.7777778e-7;
    } else if ([self.volumeUnits containsObject:unit]) {
        //to gallons
        if ([unit isEqualToString:@"gal"]) return 1;
        if ([unit isEqualToString:@"L"]) return 3.7854118;
    } else if ([self.moneyUnits containsObject:unit]) {
        //to dollars
        if ([unit isEqualToString:@"$"]) return 1;
        if ([unit isEqualToString:@"€"]) return 0.734;
    } else if ([self.massUnits containsObject:unit]) {
        //to tons
        if ([unit isEqualToString:@"ton"]) return 1;
        if ([unit isEqualToString:@"lb"]) return 2000;
        if ([unit isEqualToString:@"kg"]) return 907.18474;
    }
    [NSException raise:@"Unit does not exist" format:@"Cannot convert from unit:%@", unit];
    return 0;
}

+ (NSArray *)distanceUnits {
    return @[@"mi", @"km"];
}

+ (NSArray *)timeUnits {
    return @[@"wk", @"yr", @"mo", @"day", @"hr"];
}

+ (NSArray *)volumeUnits {
    return @[@"gal", @"L"];
}

+ (NSArray *)energyUnits {
    return @[@"J", @"ftlb", @"Btu", @"kWh"];
}

+ (NSArray *)massUnits {
    return @[@"ton", @"lb", @"kg"];
}
+ (NSArray *)moneyUnits {
    return @[@"$", @"€"];
}

+ (NSArray *)possibleUnitsForType:(CFUnitType)unitType {
    switch (unitType) {
        case UnitDistance:
        return [self distanceUnits];
        break;
        
        case UnitEnergy:
        return [self energyUnits];
        break;
        
        case UnitMass:
        return [self massUnits];
        break;
        
        case UnitTime:
        return [self timeUnits];
        break;
        
        case UnitVolume:
        return [self volumeUnits];
        break;
        
        case UnitMoney:
        return [self moneyUnits];
        break;
        
        default:
        break;
    }
    return @[@""];
}

+ (NSArray *)possibleUnitsOfSameType:(NSString *)unit index:(int *)indexRetVal {
    for (CFUnitType unitType=0; unitType<=UnitMoney; unitType++) {
        NSArray *possibles = [self possibleUnitsForType:unitType];
        if ([possibles containsObject:unit]) {
            *indexRetVal=[possibles indexOfObject:unit];
            return possibles;
        }
    }
    return nil;
}

- (void)setValueInCurrentUnits:(double)valueInCurrentUnits {
    self.value=valueInCurrentUnits*[self.class convertFrom:self.topUnit over:self.bottomUnit];
}

- (double)valueInCurrentUnits {
    return self.value/[self.class convertFrom:self.topUnit over:self.bottomUnit];
}

#pragma mark - Creation

- (instancetype)init {
    [NSException raise:@"init not available" format:@"init is unavailable for CFValue, as it must be initialized with unit types"];
    return nil;
}

- (instancetype)initWithUnitsTop:(CFUnitType)typeTop bottom:(CFUnitType)typeBottom {
    if (self=[super init]) {
        _topUnitType=typeTop;
        _bottomUnitType=typeBottom;
        self.topUnit=[self.class possibleUnitsForType:typeTop][0];
        self.bottomUnit=[self.class possibleUnitsForType:typeBottom][0];
    }
    return self;
}

#pragma mark - Storage

#define VALUE_KEY @"key for storing unit value"
#define TOP_TYPE @"key for top unit type"
#define BOTTOM_TYPE @"key for bottom unit type"
#define TOP_UNIT @"key for top unit"
#define BOTTOM_UNIT @"key for bottom unit"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[self initWithUnitsTop:[aDecoder decodeIntegerForKey:TOP_TYPE] bottom:[aDecoder decodeIntegerForKey:BOTTOM_TYPE]]) {
        self.value=[aDecoder decodeDoubleForKey:VALUE_KEY];
        self.topUnit = [aDecoder decodeObjectForKey:TOP_UNIT];
        self.bottomUnit = [aDecoder decodeObjectForKey:BOTTOM_UNIT];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.value forKey:VALUE_KEY];
    [aCoder encodeInteger:self.topUnitType forKey:TOP_TYPE];
    [aCoder encodeInteger:self.bottomUnitType forKey:BOTTOM_TYPE];
    [aCoder encodeObject:self.topUnit  forKey:TOP_UNIT];
    [aCoder encodeObject:self.bottomUnit forKey:BOTTOM_UNIT];
}

- (id)copyWithZone:(NSZone *)zone {
    CFValue *value = [[self.class alloc] initWithUnitsTop:self.topUnitType bottom:self.bottomUnitType];
    value.topUnit=self.topUnit;
    value.bottomUnit=self.bottomUnit;
    value.value=self.value;
    return value;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%g %@/%@", self.valueInCurrentUnits, self.topUnit, self.bottomUnit];
}

@end
