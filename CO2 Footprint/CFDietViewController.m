//
//  CFDietViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/18/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFDietViewController.h"
#import "CFFootprintBrain.h"
#import "CFUnitPickerViewController.h"

@interface CFDietViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CFUnitPickerDelegate>

@end

@implementation CFDietViewController

- (IBAction)sharingChanged:(UIStepper *)sender {
    self.footprint.foodShared=sender.value;
    self.sharingLabel.text=[NSString stringWithFormat:@"%g", self.footprint.foodShared];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return DIET_TYPES.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return DIET_TYPES[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.footprint.diet=row;
}

- (void)picker:(CFUnitPickerViewController *)picker pickedUnit:(NSString *)unit {
    CFValue *value = picker.valueEditing;
    if (picker.editingTop) value.topUnit=unit;
    else value.bottomUnit=unit;
    [self commitEdit];
    [self updateUnits];
}

- (IBAction)unitChange:(id)sender {
    [self performSegueWithIdentifier:@"Pick Unit" sender:sender];
}

- (void)commitEdit {
    [[NSNotificationCenter defaultCenter] postNotificationName:FOOTPRINT_CHANGED_NOTIFICATION object:nil];
}

- (void)updateUnits {
    [self.moneyUnitButton setTitle:self.footprint.groceryBill.topUnit forState:UIControlStateNormal];
    [self.timeUnitButton setTitle:self.footprint.groceryBill.bottomUnit forState:UIControlStateNormal];
    self.textField.text=[NSString stringWithFormat:@"%g", self.footprint.groceryBill.valueInCurrentUnits];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dietPicker selectRow:self.footprint.diet inComponent:0 animated:NO];
    self.sharingLabel.text=[NSString stringWithFormat:@"%g", self.footprint.foodShared];
    [self updateUnits];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.footprint.groceryBill.valueInCurrentUnits=self.textField.text.doubleValue;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 if ([segue.identifier isEqualToString:@"Pick Unit"]||UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM())
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
