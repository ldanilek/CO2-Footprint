//
//  CFActivityEditViewController.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/9/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFActivity.h"

@interface CFActivityEditViewController : UIViewController

//set this before goes onscreen
@property (strong, atomic) CFActivity *activity;

@property (nonatomic, weak) IBOutlet UIPickerView *picker;
@property (nonatomic, weak) IBOutlet UITextField *titleField;
@property (nonatomic, weak) IBOutlet UILabel *shareLabel;
@property (nonatomic, weak) IBOutlet UIStepper *shareStepper;
@property (nonatomic, weak) IBOutlet UISlider *usageSlider;
@property (nonatomic, weak) IBOutlet UILabel *usageLabel;

@end
