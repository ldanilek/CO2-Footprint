//
//  CFFootprintBrain.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFFootprintBrain.h"

@interface CFFootprintBrain ()

@end

@implementation CFFootprintBrain

#pragma mark - Default Values

- (double)homeSharing {
    if (!_homeSharing) {
        _homeSharing=1;
    }
    return _homeSharing;
}

- (double)carShared {
    if (!_carShared) {
        _carShared=1;
    }
    return _carShared;
}

- (double)foodShared {
    if (!_foodShared) {
        _foodShared=1;
    }
    return _foodShared;
}

#pragma mark - Footprint Calculations

- (double)homeFootprint {
    return 0;
}

#define TONS_PER_GALLON_OF_GASOLINE .01
#define TONS_PER_FLIGHT .5

- (double)transportFootprint {
    double milesPerGallon = self.vehicleFuelEfficiency.value;
    double milesPerWeek = self.vehicleMileage.value;
    //I want gallons per week = gallons/mile * miles/week
    double gallonsPerWeek = milesPerWeek/milesPerGallon;
    return gallonsPerWeek*TONS_PER_GALLON_OF_GASOLINE + self.numberOfFlights/52.*TONS_PER_FLIGHT;
}

- (double)dietFootprint {
    return 0;
}

- (double)footprint {
    return [self homeFootprint]+[self dietFootprint]+[self transportFootprint];
}

+ (CFValue *)newBill {
    CFValue *bill = [[CFValue alloc] initWithUnitsTop:UnitMoney bottom:UnitTime];
    bill.topUnit=@"$";
    bill.bottomUnit=@"mo";
    return bill;
}

- (CFValue *)groceryBill {
    if (!_groceryBill) {
        _groceryBill = [self.class newBill];
    }
    return _groceryBill;
}

- (CFValue *)electricBill {
    if (!_electricBill) {
        _electricBill=[self.class newBill];
    }
    return _electricBill;
}

- (CFValue *)fuelBill {
    if (!_fuelBill) {
        _fuelBill=[self.class newBill];
    }
    return _electricBill;
}

- (CFValue *)vehicleFuelEfficiency {
    if (!_vehicleFuelEfficiency) {
        _vehicleFuelEfficiency = [[CFValue alloc] initWithUnitsTop:UnitMoney bottom:UnitTime];
        _vehicleFuelEfficiency.topUnit=@"mi";
        _vehicleFuelEfficiency.bottomUnit=@"gal";
    }
    return _vehicleFuelEfficiency;
}

- (CFValue *)vehicleMileage {
    if (!_vehicleMileage) {
        _vehicleMileage = [[CFValue alloc] initWithUnitsTop:UnitDistance bottom:UnitTime];
        _vehicleMileage.topUnit=@"mi";
        _vehicleMileage.bottomUnit=@"yr";
    }
    return _vehicleMileage;
}


#pragma mark - Storage

#define HOME_TYPE @"key for home type"
#define HOME_LOCATION @"key for location of home"
#define FUEL_TYPE @"key for heating fuel"
#define FUEL_BILL @"key for heating bill"
#define ELECTRIC_BILL @"key for electric bill"
#define HOME_SHARE @"key for shared home"

#define CAR_EFFICIENCY @"key for efficiency of car fuel"
#define CAR_MILEAGE @"key for mileage of car"
#define FLIGHTS @"key for number of flights"
#define CAR_SHARE @"key for sharing car"

#define DIET_TYPE @"key for type of diet"
#define GROCERY_BILL @"key for cost of groceries"
#define FOOD_SHARE @"key for sharing food"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[self init]) {
        self.homeType=[aDecoder decodeIntForKey:HOME_TYPE];
        self.heatingFuelType=[aDecoder decodeIntForKey:FUEL_TYPE];
        self.fuelBill=[aDecoder decodeObjectForKey:FUEL_BILL];
        self.electricBill = [aDecoder decodeObjectForKey:ELECTRIC_BILL];
        self.homeState=[aDecoder decodeObjectForKey:HOME_LOCATION];
        self.homeSharing=[aDecoder decodeDoubleForKey:HOME_SHARE];
        
        self.vehicleFuelEfficiency=[aDecoder decodeObjectForKey:CAR_EFFICIENCY];
        self.vehicleMileage = [aDecoder decodeObjectForKey:CAR_MILEAGE];
        self.numberOfFlights=[aDecoder decodeIntForKey:FLIGHTS];
        self.carShared=[aDecoder decodeDoubleForKey:CAR_SHARE];
        
        self.diet=[aDecoder decodeIntForKey:DIET_TYPE];
        self.groceryBill=[aDecoder decodeObjectForKey:GROCERY_BILL];
        self.foodShared=[aDecoder decodeDoubleForKey:FOOD_SHARE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.fuelBill forKey:FUEL_BILL];
    [aCoder encodeInteger:self.homeType forKey:HOME_TYPE];
    [aCoder encodeInteger:self.heatingFuelType forKey:FUEL_TYPE];
    [aCoder encodeObject:self.electricBill forKey:ELECTRIC_BILL];
    [aCoder encodeObject:self.homeState forKey:HOME_LOCATION];
    [aCoder encodeDouble:self.homeSharing forKey:HOME_SHARE];
    
    [aCoder encodeObject:self.vehicleFuelEfficiency forKey:CAR_EFFICIENCY];
    [aCoder encodeObject:self.vehicleMileage forKey:CAR_MILEAGE];
    [aCoder encodeInteger:self.numberOfFlights forKey:FLIGHTS];
    [aCoder encodeDouble:self.carShared forKey:CAR_SHARE];
    
    [aCoder encodeObject:self.groceryBill forKey:GROCERY_BILL];
    [aCoder encodeInteger:self.diet forKey:DIET_TYPE];
    [aCoder encodeDouble:self.foodShared forKey:FOOD_SHARE];
}

@end
