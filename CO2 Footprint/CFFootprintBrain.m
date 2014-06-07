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

- (NSArray *)keywordsForSectionTitle:(NSString *)sectionTitle {
    NSMutableArray *keywords = [@[] mutableCopy];
    if ([sectionTitle isEqual:@"Home"]) {
        [keywords addObject:@"Chill out"];
        [keywords addObject:@"Power off"];
        
    }if ([sectionTitle isEqual:@"Transportation"]) {
        [keywords addObject:@"Carpool"];
        [keywords addObject:@"Shortcut"];
    }
    if ([sectionTitle isEqual:@"Diet"]) {
        [keywords addObject:@"Eat better"];
    }
    [keywords filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        return [self explanationForKeyword:evaluatedObject]!=nil;
    }]];
    return [keywords copy];
}

- (NSString *)explanationForKeyword:(NSString *)keyword {
    if ([keyword isEqual:@"Chill out"]&&self.fuelBill.value>1&&self.heatingFuelType!=HeatingFuelNone) {
        return @"Use 25% less fuel";
    }
    if ([keyword isEqual:@"Power off"]) {
        return @"Use 25% less electricity";
    }
    if ([keyword isEqual:@"Carpool"]&&self.vehicleMileage.value>1&&self.carShared<5) {
        return @"Drive with 2 more people";
    }
    if ([keyword isEqual:@"Shortcut"]&&self.vehicleMileage.value>1) {
        return @"Drive 5% less";
    }
    if ([keyword isEqual:@"Eat better"] && self.diet>DietVegan) {
        NSString *identifier;
        switch (self.diet-1) {
            case DietAverage:
                identifier=@"an average";
                break;
                
            case DietNoBeef:
                identifier=@"a no-beef";
                break;
                
            case DietVegetarian:
                identifier=@"a vegetarian";
                break;
                
            case DietVegan:
                identifier=@"a vegan";
                break;
                
            default:
                break;
        }
        return [NSString stringWithFormat:@"Adopt %@ diet", identifier];
    }
    return nil;
}

- (double)savingsForKeyword:(NSString *)keyword {
    if ([keyword isEqual:@"Chill out"]) {
        self.fuelBill.value*=3./4;
        double footprint = self.homeFootprint;
        self.fuelBill.value/=3./4;
        return self.homeFootprint-footprint;
    }
    if ([keyword isEqual:@"Power off"]) {
        self.electricBill.value*=3./4;
        double newFoot = self.homeFootprint;
        self.electricBill.value/=3./4;
        return self.homeFootprint-newFoot;
    }
    if ([keyword isEqual:@"Carpool"]) {
        self.carShared+=2;
        double newFoot = self.transportFootprint;
        self.carShared-=2;
        return self.transportFootprint-newFoot;
    }
    if ([keyword isEqual:@"Eat better"] && self.diet>DietVegan) {
        self.diet--;
        double newFoot = self.dietFootprint;
        self.diet++;
        return self.dietFootprint-newFoot;
    }
    if ([keyword isEqual:@"Shortcut"]) {
        self.vehicleMileage.value*=.95;
        double newFoot = self.transportFootprint;
        self.vehicleMileage.value/=.95;
        return self.transportFootprint-newFoot;
    }
    return 0;
}

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

//1 dollar per month of electricity releases 77 pounds per year
//1 dollar per month releases 77/2000/12 tons per month
#define ELECTRIC_TONS_PER_DOLLAR 6.4166666666/2000;

- (double)homeFootprint {
    double tonsPerDollar = 0;
    switch (self.heatingFuelType) {
        case HeatingFuelNaturalGas:
            tonsPerDollar = GAS_TONS_PER_$;
            break;
            
        case HeatingFuelOil:
            tonsPerDollar = OIL_TONS_PER_$;
            break;
            
        case HeatingFuelPropane:
            tonsPerDollar = PROPANE_TONS_PER_$;
            break;
            
        case HeatingFuelPellets:
            tonsPerDollar = PELLET_TONS_PER_$;
            break;
           
        default:
            break;
    }
    double fuelFootprint = self.fuelBill.value * tonsPerDollar;//in tons/wk
    
    double electricityFootprint=self.electricBill.value * ELECTRIC_TONS_PER_DOLLAR;
    
    return fuelFootprint+electricityFootprint;
}

//1 mile/gallon for 1 mi/wk releases 1062 pounds per year
//1 gal/wk releases 1062 pounds/yr * 0.019164956 yr/wk * ton/2000 pounds
//1 gal of gasoline releases 20.421053 lbs of CO2
#define TONS_PER_GALLON_OF_GASOLINE .0102105265

#define TONS_PER_SHORT_FLIGHT .25
#define TONS_PER_MEDIUM_FLIGHT 1.25/2
#define TONS_PER_LONG_FLIGHT 1.
//from http://www.terrapass.com/carbon-footprint-calculator-2/#air

- (double)transportFootprint {
    double milesPerGallon = self.vehicleFuelEfficiency.value;
    double milesPerWeek = self.vehicleMileage.value;
    //I want gallons per week = gallons/mile * miles/week
    double gallonsPerWeek = milesPerWeek/milesPerGallon;
    
    CFValue *converter = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    converter.topUnit=@"ton";
    converter.bottomUnit=@"yr";
    
    double plane=0;
    converter.valueInCurrentUnits=self.shortFlights*TONS_PER_SHORT_FLIGHT;
    plane += converter.value;
    converter.valueInCurrentUnits=self.mediumFlights*TONS_PER_MEDIUM_FLIGHT;
    plane += converter.value;
    converter.valueInCurrentUnits=self.longFlights*TONS_PER_LONG_FLIGHT;
    plane += converter.value;
    
    double footprint = gallonsPerWeek*TONS_PER_GALLON_OF_GASOLINE/self.carShared + plane;
    return footprint;
}

- (double)dietFootprint {
    //http://shrinkthatfootprint.com/food-carbon-footprint-diet
    double tonsPerYear = 0;
    switch (self.diet) {
        case DietMeatLover:
            tonsPerYear=3.3;
            break;
            
        case DietAverage:
            tonsPerYear=2.5;
            break;
            
        case DietNoBeef:
            tonsPerYear=1.9;
            break;
            
        case DietVegetarian:
            tonsPerYear=1.7;
            break;
            
        case DietVegan:
            tonsPerYear=1.5;
            break;
            
        default:
            break;
    }
    CFValue *perYear = [[CFValue alloc] initWithUnitsTop:UnitVolume bottom:UnitTime];
    perYear.topUnit=@"ton";
    perYear.bottomUnit=@"yr";
    perYear.valueInCurrentUnits=tonsPerYear;
    return perYear.value;
}

- (double)footprint {
    return [self homeFootprint]+[self dietFootprint]+[self transportFootprint];
}

- (double)yearlyFootprint {
    CFValue *converter = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    converter.topUnit=@"ton";
    converter.bottomUnit=@"yr";
    converter.value=self.footprint;
    return converter.valueInCurrentUnits;
}

#define HUMAN_POPULATION 7170277060//june 3 2014 6:45pm

- (double)yearlyFootprintExtrapolated {
    return self.yearlyFootprint*HUMAN_POPULATION;
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
    return _fuelBill;
}

- (CFValue *)vehicleFuelEfficiency {
    if (!_vehicleFuelEfficiency) {
        _vehicleFuelEfficiency = [[CFValue alloc] initWithUnitsTop:UnitMoney bottom:UnitTime];
        _vehicleFuelEfficiency.topUnit=@"mi";
        _vehicleFuelEfficiency.bottomUnit=@"gal";
        _vehicleFuelEfficiency.valueInCurrentUnits=20;
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
#define FLIGHTS_S @"key for number of short flights"
#define FLIGHTS_M @"key for number of medium flights"
#define FLIGHTS_L @"key for number of long flights"
#define CAR_SHARE @"key for sharing car"

#define DIET_TYPE @"key for type of diet"
#define GROCERY_BILL @"key for cost of groceries"
#define FOOD_SHARE @"key for sharing food"

- (instancetype)init {
    if (self=[super init]) {
        self.diet=DietAverage;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[self init]) {
        //self.homeType=[aDecoder decodeIntForKey:HOME_TYPE];
        self.heatingFuelType=[aDecoder decodeIntForKey:FUEL_TYPE];
        self.fuelBill=[[aDecoder decodeObjectForKey:FUEL_BILL] copy];
        self.electricBill = [[aDecoder decodeObjectForKey:ELECTRIC_BILL] copy];
        //self.homeState=[aDecoder decodeObjectForKey:HOME_LOCATION];
        self.homeSharing=[aDecoder decodeDoubleForKey:HOME_SHARE];
        
        self.vehicleFuelEfficiency=[aDecoder decodeObjectForKey:CAR_EFFICIENCY];
        self.vehicleMileage = [aDecoder decodeObjectForKey:CAR_MILEAGE];
        self.shortFlights=[aDecoder decodeIntForKey:FLIGHTS_S];
        self.mediumFlights=[aDecoder decodeIntForKey:FLIGHTS_M];
        self.longFlights=[aDecoder decodeIntForKey:FLIGHTS_L];
        self.carShared=[aDecoder decodeDoubleForKey:CAR_SHARE];
        
        self.diet=[aDecoder decodeIntForKey:DIET_TYPE];
        self.groceryBill=[aDecoder decodeObjectForKey:GROCERY_BILL];
        self.foodShared=[aDecoder decodeDoubleForKey:FOOD_SHARE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.fuelBill forKey:FUEL_BILL];
    //[aCoder encodeInteger:self.homeType forKey:HOME_TYPE];
    [aCoder encodeInteger:self.heatingFuelType forKey:FUEL_TYPE];
    [aCoder encodeObject:self.electricBill forKey:ELECTRIC_BILL];
    //[aCoder encodeObject:self.homeState forKey:HOME_LOCATION];
    [aCoder encodeDouble:self.homeSharing forKey:HOME_SHARE];
    
    [aCoder encodeObject:self.vehicleFuelEfficiency forKey:CAR_EFFICIENCY];
    [aCoder encodeObject:self.vehicleMileage forKey:CAR_MILEAGE];
    [aCoder encodeInteger:self.shortFlights forKey:FLIGHTS_S];
    [aCoder encodeInteger:self.mediumFlights forKey:FLIGHTS_M];
    [aCoder encodeInteger:self.longFlights forKey:FLIGHTS_L];
    [aCoder encodeDouble:self.carShared forKey:CAR_SHARE];
    
    [aCoder encodeObject:self.groceryBill forKey:GROCERY_BILL];
    [aCoder encodeInteger:self.diet forKey:DIET_TYPE];
    [aCoder encodeDouble:self.foodShared forKey:FOOD_SHARE];
}

@end
