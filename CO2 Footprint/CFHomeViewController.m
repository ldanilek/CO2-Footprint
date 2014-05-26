//
//  CFHomeViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/18/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFHomeViewController.h"
#import "CFFootprintBrain.h"
#import "CFUnitPickerViewController.h"

@interface CFHomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CFUnitPickerDelegate>

@end

@implementation CFHomeViewController

- (void)updateUnits {
    self.fuelBill.text=[NSString stringWithFormat:@"%g", self.footprint.fuelBill.valueInCurrentUnits];
    self.electricBill.text=[NSString stringWithFormat:@"%g", self.footprint.electricBill.valueInCurrentUnits];
    [self.fuelMoneyUnitButton setTitle:self.footprint.fuelBill.topUnit forState:UIControlStateNormal];
    [self.fuelTimeUnitButton setTitle:self.footprint.fuelBill.bottomUnit forState:UIControlStateNormal];
    [self.electricMoneyUnitButton setTitle:self.footprint.electricBill.topUnit forState:UIControlStateNormal];
    [self.electricTimeUnitButton setTitle:self.footprint.electricBill.bottomUnit forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.fuelTypePicker selectRow:self.footprint.heatingFuelType inComponent:0 animated:NO];
    [self.homeTypePicker selectRow:self.footprint.homeType inComponent:0 animated:NO];
    self.sharingLabel.text=[NSString stringWithFormat:@"%g", self.footprint.homeSharing];
    self.stepper.value=self.footprint.homeSharing;
    [self updateUnits];
}

- (IBAction)sharingChanged:(UIStepper *)sender {
    self.footprint.homeSharing=sender.value;
    self.sharingLabel.text=[NSString stringWithFormat:@"%g", self.footprint.homeSharing];
    [self commitEdit];
}

- (IBAction)unitChange:(id)sender {
    [self performSegueWithIdentifier:@"Pick Unit" sender:sender];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==self.homeTypePicker) {
        return HOME_TYPES.count;
    } else if (pickerView==self.fuelTypePicker) {
        return HEATING_TYPES.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView==self.homeTypePicker) {
        return HOME_TYPES[row];
    } else if (pickerView==self.fuelTypePicker) {
        return HEATING_TYPES[row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView==self.homeTypePicker) {
        self.footprint.homeType=(int)row;
    } else if (pickerView==self.fuelTypePicker) {
        self.footprint.heatingFuelType=(int)row;
    }
}

- (void)picker:(CFUnitPickerViewController *)picker pickedUnit:(NSString *)unit {
    CFValue *value = picker.valueEditing;
    if (picker.editingTop) value.topUnit=unit;
    else value.bottomUnit=unit;
    [self commitEdit];
    [self updateUnits];
}

- (void)commitEdit {
    [[NSNotificationCenter defaultCenter] postNotificationName:FOOTPRINT_CHANGED_NOTIFICATION object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.fuelBill queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.footprint.fuelBill.valueInCurrentUnits=self.fuelBill.text.doubleValue;
        [self commitEdit];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.electricBill queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.footprint.electricBill.valueInCurrentUnits=self.electricBill.text.doubleValue;
        [self commitEdit];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    CFUnitPickerViewController *picker = segue.destinationViewController;
    picker.delegate=self;
    int index = 0;
    picker.possibilities=[CFValue possibleUnitsOfSameType:sender.currentTitle index:&index];
    picker.startingIndex=index;
    if (sender==self.fuelMoneyUnitButton||sender==self.fuelTimeUnitButton) {
        picker.valueEditing=self.footprint.fuelBill;
        picker.editingTop=sender==self.fuelMoneyUnitButton;
    } else {
        picker.valueEditing=self.footprint.electricBill;
        picker.editingTop=sender==self.electricMoneyUnitButton;
    }
}


@end
