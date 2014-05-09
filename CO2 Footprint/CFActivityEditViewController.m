//
//  CFActivityEditViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/9/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFActivityEditViewController.h"
#import "CFFootprintBrain.h"

@interface CFActivityEditViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation CFActivityEditViewController

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return subtypeCount(self.activity.type);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return stringForSubtype(self.activity.type, row);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.activity.subtype=row;
    [self commitEdit];
}

- (void)commitEdit {
    [[NSNotificationCenter defaultCenter] postNotificationName:FOOTPRINT_CHANGED_NOTIFICATION object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.picker selectRow:self.activity.subtype inComponent:0 animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
