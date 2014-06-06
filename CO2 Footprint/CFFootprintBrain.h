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

//25kg of C per GJ * 17MJ per kg of fuel according to http://www.biomassenergycentre.org.uk/portal/page?_pageid=75,163182&_dad=portal&_schema=PORTAL = .425 kg of C per kg of Fuel = .000425 tons per kg of Fuel
//247$ per ton according to http://publicservice.vermont.gov/sites/psd/files/MAY-2014%20Fuel%20Price%20Report.pdf = $.2723 per kg of fuel
//total 3.12156 pounds of CO2 per $ of Fuel
#define PELLET_TONS_PER_$ 3.12156/2000

typedef enum {
    HeatingFuelNaturalGas,//for one dollar, release 10.75 pounds of CO2
    HeatingFuelOil,//for one dollar, release 8.08333 pounds of CO2
    HeatingFuelPropane,//for one dollar, release 4.83333 pounds of CO2
    HeatingFuelPellets,
    HeatingFuelNone,//release no CO2
} HeatingFuelType;
#define HEATING_TYPES @[@"Natural Gas", @"Oil", @"Propane", @"Pellets", @"None"]

typedef enum {
    DietVegan,
    DietVegetarian,
    DietNoBeef,
    DietAverage,
    DietMeatLover
} DietType;
#define DIET_TYPES @[@"Vegan", @"Vegetarian", @"No Beef", @"Average", @"Meat Lover"]

//data from http://www.epa.gov/climatechange/ghgemissions/ind-calculator.html#c=transportation&p=reduceOnTheRoad&m=calc_currentEmissions

//tons are being used here to mean short ton = 2000 pounds

@interface CFFootprintBrain : NSObject <NSCoding>

//initializing from NSKeyedUnarchiver is encouraged, when possible
//otherwise, create a blank footprint with the designated initializer init

- (double)yearlyFootprint;//tons per year
- (double)yearlyFootprintExtrapolated;//tons per year times human population
- (double)footprint;//in tons of carbon per week
//all footprints are per week

//no more individual activities
//just the three categories: Home, Transportation, and Diet
#pragma mark - Home
//@property (nonatomic) HomeType homeType;
@property (nonatomic) HeatingFuelType heatingFuelType;
//@property (nonatomic, strong) NSString *homeState;
//all bills are default $/mo
@property (nonatomic, strong) CFValue *fuelBill;
@property (nonatomic, strong) CFValue *electricBill;
@property (nonatomic) double homeSharing;

- (double)homeFootprint;

#pragma mark - Transportation
@property (nonatomic, strong) CFValue *vehicleFuelEfficiency;//default miles/gal
@property (nonatomic, strong) CFValue *vehicleMileage;//default miles/yr
//round trips
@property (nonatomic) int shortFlights;//two hours each way
@property (nonatomic) int mediumFlights;//four hours each way
@property (nonatomic) int longFlights;//more
@property (nonatomic) double carShared;

- (double)transportFootprint;

#pragma mark - Diet
@property (nonatomic) DietType diet;
@property (nonatomic) CFValue *groceryBill;
@property (nonatomic) double foodShared;
//include eating out?

- (double)dietFootprint;

- (NSArray *)keywordsForSectionTitle:(NSString *)sectionTitle;
- (NSString *)explanationForKeyword:(NSString *)keyword;
- (double)savingsForKeyword:(NSString *)keyword;//in tons per week

@end
