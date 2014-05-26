//
//  CO2_FootprintTests.m
//  CO2 FootprintTests
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CFFootprintBrain.h"

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

#pragma mark - Test Units

- (void)testUnits {
    CFValue *value = [[CFValue alloc] initWithUnitsTop:UnitDistance bottom:UnitTime];
    value.topUnit=@"km";
    value.bottomUnit=@"hr";
    value.valueInCurrentUnits=20;
    XCTAssertEqualWithAccuracy(value.valueInCurrentUnits, 20, .001, @"convert to and fro");
    XCTAssertEqualWithAccuracy(2088, value.value, 1, @"store as mi/wk");
}

#pragma mark - Test Specific Footprints

- (void)testCarFootprint {
    CFValue *footprintExpected = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    footprintExpected.topUnit=@"lb";
    footprintExpected.bottomUnit=@"yr";
    
    CFFootprintBrain *footprint = [[CFFootprintBrain alloc] init];
    footprint.vehicleFuelEfficiency.valueInCurrentUnits=1;
    footprint.vehicleMileage.valueInCurrentUnits=1;
    footprintExpected.valueInCurrentUnits=20;
    XCTAssertEqualWithAccuracy(footprintExpected.value, [footprint transportFootprint], .0001, @"Simple vehicle footprint");
    
    footprint.vehicleFuelEfficiency.valueInCurrentUnits=20;//mi/gal
    footprint.vehicleMileage.valueInCurrentUnits=12500;//mi/yr
    
    footprintExpected.valueInCurrentUnits=12763;
    XCTAssertEqualWithAccuracy(footprintExpected.value, [footprint transportFootprint], .1, @"Footprint due to vehicle");
}

- (void)testPlaneFootprint {
    
}

- (void)testElectricFootprint {
    CFFootprintBrain *footprint = [[CFFootprintBrain alloc] init];
    footprint.electricBill.valueInCurrentUnits=43;
    CFValue *footprintExpected = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    footprintExpected.topUnit=@"lb";
    footprintExpected.bottomUnit=@"yr";
    footprintExpected.valueInCurrentUnits=3295;
    XCTAssertEqualWithAccuracy([footprint homeFootprint], footprintExpected.value, .1, @"Electric bill estimate footprint");
    
    footprint.electricBill.valueInCurrentUnits=150;
    footprintExpected.valueInCurrentUnits=11493;
    XCTAssertEqualWithAccuracy([footprint homeFootprint], footprintExpected.value, .1, @"electric footprint");
}

- (void)testNaturalGasFootprint {
    CFValue *footprintExpected = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    footprintExpected.topUnit=@"lb";
    footprintExpected.bottomUnit=@"yr";
    
    CFFootprintBrain *footprint = [[CFFootprintBrain alloc] init];
    footprint.heatingFuelType=HeatingFuelNaturalGas;
    footprint.fuelBill.valueInCurrentUnits = 24;
    
    footprintExpected.valueInCurrentUnits=3086;
    XCTAssertEqualWithAccuracy([footprint homeFootprint], footprintExpected.value, .1, @"Natural gas footprint");
}

- (void)testOilFootprint {
    CFValue *footprintExpected = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    footprintExpected.topUnit=@"lb";
    footprintExpected.bottomUnit=@"yr";
    
    CFFootprintBrain *footprint = [[CFFootprintBrain alloc] init];
    footprint.heatingFuelType=HeatingFuelOil;
    footprint.fuelBill.valueInCurrentUnits = 67;
    
    footprintExpected.valueInCurrentUnits=6492;
    XCTAssertEqualWithAccuracy([footprint homeFootprint], footprintExpected.value, .1, @"Oil footprint");
}

- (void)testPropaneFootprint {
    CFValue *footprintExpected = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    footprintExpected.topUnit=@"lb";
    footprintExpected.bottomUnit=@"yr";
    
    CFFootprintBrain *footprint = [[CFFootprintBrain alloc] init];
    footprint.heatingFuelType=HeatingFuelPropane;
    footprint.fuelBill.valueInCurrentUnits = 38;
    
    footprintExpected.valueInCurrentUnits=2188;
    XCTAssertEqualWithAccuracy([footprint homeFootprint], footprintExpected.value, .1, @"Propane footprint");
}

- (void)testPelletFootprint {
    CFValue *footprintExpected = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    footprintExpected.topUnit=@"lb";
    footprintExpected.bottomUnit=@"yr";
    
    CFFootprintBrain *footprint = [[CFFootprintBrain alloc] init];
    footprint.heatingFuelType=HeatingFuelOil;
    footprint.fuelBill.valueInCurrentUnits = 67;
    
    footprintExpected.valueInCurrentUnits=6492;
}

@end
