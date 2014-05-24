//
//  CFDietViewController.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/18/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFFootprintBrain.h"

@interface CFDietViewController : UIViewController

@property (atomic, strong) CFFootprintBrain *footprint;
- (void)updateUnits;

@property (nonatomic, weak) IBOutlet UIPickerView *dietPicker;

- (IBAction)sharingChanged:(UIStepper *)sender;
@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@property (nonatomic, weak) IBOutlet UILabel *sharingLabel;

@property (nonatomic, weak) IBOutlet UIButton *moneyUnitButton;
- (IBAction)unitChange:(id)sender;
@property (nonatomic, weak) IBOutlet UIButton *timeUnitButton;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
