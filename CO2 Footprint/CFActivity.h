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

#define TYPES_STRING_ARRAY @[@"Transportation",@"Hygiene",@"Work",@"Leisure",@"Surviving"]

static int typeCount() {
    static int count=0;
    if (!count) count = [TYPES_STRING_ARRAY count];
    return count;
}
static NSString *stringForType(ActivityType type) {
    return TYPES_STRING_ARRAY[type];
}

typedef NSUInteger ActivitySubtype;//subtype is an integer from one of the ACTIVITY_SUBTYPES defined below

@interface CFActivity : NSObject <NSCoding>
//responds accurately to isEqual: and hash
//responds to description for debugging

- (NSString *)display;//not for debugging. for display in table view (must be short)

//usually will be initialized from NSKeyedUnarchiver, but when that's not available, call initWithType:, the designated initializer
- (instancetype)initWithType:(ActivityType)activityType;
//init throws an exception, because an activity must be created with a type

@property (nonatomic, readonly) double footprint;//in tons of CO2 per week

- (NSString *)stringForType;
- (NSString *)stringForSubtype;

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

typedef enum {
    LeisureTV,
} LeisureType;

//when subtypes or types are edited, this must be edited as well
#define SUBTYPES_STRING_ARRAY @[@[@"Plane",@"Car",@"Truck",@"Bus"], @[@"Bath", @"Shower",@"Brush Teeth", @"Wash Clothes", @"Dry Clothes",@"Wash Hands",@"Dishwasher",@"Vacuum"], @[@"Lights",@"Computer"], @[@"Heat",@"Air Conditioning",@"Food",@"Drink"],@[@"TV"]]

static int subtypeCount(ActivityType type) {
    return [SUBTYPES_STRING_ARRAY[type] count];
}

static NSString *stringForSubtype(ActivityType type, ActivitySubtype subtype) {
    return SUBTYPES_STRING_ARRAY[type][subtype];
}
