//
//  CFFootprintBrain.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFValue.h"

#define FOOTPRINT_CHANGED_NOTIFICATION @"Note: the footprint has now changed. Store it now."
//changing from Activities to Input categories

typedef enum {
    HomeHouse,
    HomeApartment,
} HomeType;
#define HOME_TYPES @[@"House", @"Apartment"]

#define GAS_TONS_PER_$ 10.75/2000
#define OIL_TONS_PER_$ 8.0833333/2000
#define PROPANE_TONS_PER_$ 4.8333333/2000

#define PELLET_TONS_PER_$ 8.0833333/2000

typedef enum {
    HeatingFuelNaturalGas,//for one dollar, release 10.75 pounds of CO2
    HeatingFuelOil,//for one dollar, release 8.08333 pounds of CO2
    HeatingFuelPropane,//for one dollar, release 4.83333 pounds of CO2
    //HeatingFuelPellets,
    HeatingFuelNone,//release no CO2
} HeatingFuelType;
#define HEATING_TYPES @[@"Natural Gas", @"Oil", @"Propane",/* @"Pellets",*/ @"None"]

typedef enum {
    DietVegan,
    DietVegetarian,
    DietOmnivore,
    DietCarnivore
} DietType;
#define DIET_TYPES @[@"Vegan", @"Vegetarian", @"Omnivore", @"Carnivore"]

//data from http://www.epa.gov/climatechange/ghgemissions/ind-calculator.html#c=transportation&p=reduceOnTheRoad&m=calc_currentEmissions

//tons are being used here to mean short ton = 2000 pounds

@interface CFFootprintBrain : NSObject <NSCoding>

//initializing from NSKeyedUnarchiver is encouraged, when possible
//otherwise, create a blank footprint with the designated initializer init

- (double)footprint;//in tons of carbon per week
//all footprints are per week

//no more individual activities
//just the three categories: Home, Transportation, and Diet
#pragma mark - Home
@property (nonatomic) HomeType homeType;
@property (nonatomic) HeatingFuelType heatingFuelType;
@property (nonatomic, strong) NSString *homeState;
//all bills are default $/mo
@property (nonatomic, strong) CFValue *fuelBill;
@property (nonatomic, strong) CFValue *electricBill;
@property (nonatomic) double homeSharing;

- (double)homeFootprint;

#pragma mark - Transportation
@property (nonatomic, strong) CFValue *vehicleFuelEfficiency;//default miles/gal
@property (nonatomic, strong) CFValue *vehicleMileage;//default miles/yr
@property (nonatomic) int numberOfFlights;//per year
@property (nonatomic) double carShared;

- (double)transportFootprint;

#pragma mark - Diet
@property (nonatomic) DietType diet;
@property (nonatomic) CFValue *groceryBill;
@property (nonatomic) double foodShared;
//include eating out?

- (double)dietFootprint;

@end
