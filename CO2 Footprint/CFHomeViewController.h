//
//  CFHomeViewController.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/18/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFFootprintBrain.h"

@interface CFHomeViewController : UIViewController

@property (atomic, strong) CFFootprintBrain *footprint;
- (void)updateUnits;


@property (nonatomic, weak) IBOutlet UIPickerView *homeTypePicker;
@property (nonatomic, weak) IBOutlet UIPickerView *fuelTypePicker;

- (IBAction)sharingChanged:(UIStepper *)sender;
@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@property (nonatomic, weak) IBOutlet UILabel *sharingLabel;

@property (nonatomic, weak) IBOutlet UIButton *fuelMoneyUnitButton;
@property (nonatomic, weak) IBOutlet UIButton *fuelTimeUnitButton;
- (IBAction)unitChange:(id)sender;
@property (nonatomic, weak) IBOutlet UIButton *electricMoneyUnitButton;
@property (nonatomic, weak) IBOutlet UIButton *electricTimeUnitButton;
@property (nonatomic, weak) IBOutlet UITextField *fuelBill;
@property (nonatomic, weak) IBOutlet UITextField *electricBill;

@end
