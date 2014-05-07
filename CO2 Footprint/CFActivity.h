//
//  CFActivity.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ActivityTransportation,//like driving
    ActivityHygiene,//like washing/cleaning
    ActivityWorking,//like lights
    ActivitySurviving,//like eating
    ActivityLeisure//like TV
} ActivityType;

typedef NSUInteger ActivitySubtype;//subtype is an integer from one of the ACTIVITY_SUBTYPES defined below

@interface CFActivity : NSObject <NSCoding>

//usually will be initialized from NSKeyedUnarchiver, but when that's not available, call initWithType:, the designated initializer
- (instancetype)initWithType:(ActivityType)activityType;
//init throws an exception, because an activity must be created with a type

- (double)footprint;//in tons of CO2 per week

//for storage
@property (nonatomic, readonly) ActivityType type;
//editable attributes
@property (nonatomic) ActivitySubtype subtype;
@property (nonatomic, strong) NSString *title;
//these next two could be inputted together, but they are stored separately. they are optional
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic) double sharingCount;//people sharing the activity. total footprint is divided by this number to distribute evenly.
@property (nonatomic) double efficiency;//this will often be determined/estimated automatically. usually miles/gallon or (hours to use one unit of power)
@property (nonatomic) double usage;//per week, how many hours is it used, or how many miles are driven, etc.

@end

#pragma mark - ACTIVITY_SUBTYPES

typedef enum {
    TransportationPlane,
    TransportationCar,
    TransportationTruck,
    TransportationBus
} TransportationType;

typedef enum {
    HygieneBath,
    HygieneShower,
    HygieneBrushTeeth,
    HygieneWashClothes,
    HygieneDryClothes,
    HygieneWashHands,
    HygieneDishwasher,
    HygieneVacuum,
} HygieneType;

typedef enum {
    WorkingLights,
    WorkingComputer,
} WorkingType;

typedef enum {
    SurvivingHeat,
    SurvivingAC,
    SurvivingFood,
    SurvivingDrink,
} SurvivingType;

