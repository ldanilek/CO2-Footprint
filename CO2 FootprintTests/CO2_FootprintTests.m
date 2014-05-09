//
//  CO2_FootprintTests.m
//  CO2 FootprintTests
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CFActivity.h"

@interface CO2_FootprintTests : XCTestCase

@end

@implementation CO2_FootprintTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Test Activities

- (void)testActivityCreation {
    CFActivity *activity = [[CFActivity alloc] initWithType:ActivityTransportation];
    XCTAssertNotNil(activity, @"activity should not be nil");
    XCTAssertEqual(activity.type, ActivityTransportation, @"type is set on init");
}

//also checks activity editing and comparison
- (void)testActivityStorage {
    CFActivity *activity = [[CFActivity alloc] initWithType:ActivityTransportation];
    activity.title=@"Daily Commute";
    activity.subtype=TransportationCar;
    activity.brand=@"Honda";
    activity.model=@"Pilot";
    activity.efficiency=20;
    activity.usage=50;
    activity.sharingCount=2;
    
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:activity];
    CFActivity *resurected = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
    
    XCTAssertNotNil(resurected, @"accessed activity should exist");
    XCTAssertEqual(resurected.type, activity.type, @"accessed activity should retain type");
    XCTAssertEqualObjects(activity, resurected, @"activity and resurected activity should be the same");//this also checks isEqual:
    XCTAssertNoThrow(NSLog(@"Activity has been recreated:\n%@", activity), @"Check description");
}

#pragma mark - Test Specific Footprints

@end
