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

typedef enum {
    HeatingFuelGas,
    HeatingFuelPropane,
    HeatingFuelPellets,
    HeatingFuelNone,
} HeatingFuelType;
#define HEATING_TYPES @[@"Gas", @"Propane", @"Pellets", @"None"]

typedef enum {
    DietVegan,
    DietVegetarian,
    DietOmnivore,
    DietCarnivore
} DietType;
#define DIET_TYPES @[@"Vegan", @"Vegetarian", @"Omnivore", @"Carnivore"]

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
@property (nonatomic, strong) CFValue *fuelBill;
@property (nonatomic, strong) CFValue *electricBill;
@property (nonatomic) double homeSharing;

- (double)homeFootprint;

#pragma mark - Transportation
@property (nonatomic, strong) CFValue *vehicleFuelEfficiency;
@property (nonatomic, strong) CFValue *vehicleMileage;
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
