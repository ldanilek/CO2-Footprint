//
//  CFTransportViewController.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/18/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFFootprintBrain.h"

@interface CFTransportViewController : UIViewController

@property (atomic, strong) CFFootprintBrain *footprint;
- (void)updateUnits;

@property (nonatomic, weak) IBOutlet UIButton *efficiencyTop;
@property (nonatomic, weak) IBOutlet UIButton *efficiencyBottom;
@property (nonatomic, weak) IBOutlet UIButton *mileageTop;
@property (nonatomic, weak) IBOutlet UIButton *mileageBottom;

@property (nonatomic, weak) IBOutlet UITextField *efficiency;
@property (nonatomic, weak) IBOutlet UITextField *mileage;
@property (nonatomic, weak) IBOutlet UILabel *sharing;
@property (nonatomic, weak) IBOutlet UIStepper *sharingStepper;

@property (nonatomic, weak) IBOutlet UILabel *numberOfShortFlights;
@property (nonatomic, weak) IBOutlet UIStepper *shortFlightsStepper;
@property (nonatomic, weak) IBOutlet UILabel *numberOfMediumFlights;
@property (nonatomic, weak) IBOutlet UIStepper *mediumFlightsStepper;
@property (nonatomic, weak) IBOutlet UILabel *numberOfLongFlights;
@property (nonatomic, weak) IBOutlet UIStepper *longFlightsStepper;

- (IBAction)flightsChanged:(id)sender;
- (IBAction)sharingChanged:(id)sender;

- (IBAction)changeUnit:(id)sender;

@end
