//
//  CFActivityEditViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/9/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFActivityEditViewController.h"
#import "CFFootprintBrain.h"
#import "CFUnitPickerViewController.h"

@interface CFActivityEditViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CFUnitPickerDelegate>

@end

@implementation CFActivityEditViewController

- (IBAction)editUnit:(id)sender {
    [self performSegueWithIdentifier:@"Pick Unit" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Pick Unit"]) {
        int unitToEdit = 4;
        if (sender==self.efficiencyTopUnit) unitToEdit=2;
        if (sender==self.efficiencyBottomUnit) unitToEdit=3;
        if (sender==self.usageTopUnit) unitToEdit=0;
        if (sender==self.usageBottomUnit) unitToEdit=1;
        CFUnitPickerViewController *picker = segue.destinationViewController;
        picker.possibilities=[self.activity possibleUnitsForIndex:unitToEdit];
        picker.unitIndex=unitToEdit;
        picker.delegate=self;
        picker.startingIndex=[self.activity currentUnitForIndex:unitToEdit];
    }
}

- (void)picker:(CFUnitPickerViewController *)picker pickedUnit:(NSString *)unit {
    self.activity.units[picker.unitIndex]=unit;
    [self updateUnits];
    [self commitEdit];
}

- (void)updateUnits {
    [self.usageTopUnit setTitle:self.activity.units[0] forState:UIControlStateNormal];
    [self.usageBottomUnit setTitle:self.activity.units[1] forState:UIControlStateNormal];
    [self.efficiencyTopUnit setTitle:self.activity.units[2] forState:UIControlStateNormal];
    [self.efficiencyBottomUnit setTitle:self.activity.units[3] forState:UIControlStateNormal];
    self.usageLabel.text=[NSString stringWithFormat:@"%g", self.activity.usageInCurrentUnits];
    self.efficiencyLabel.text=[NSString stringWithFormat:@"%g", self.activity.efficiencyInCurrentUnits];
}

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.picker selectRow:self.activity.subtype inComponent:0 animated:NO];
    self.usageLabel.text=[NSString stringWithFormat:@"%g", self.activity.usageInCurrentUnits];
    self.efficiencyLabel.text=[NSString stringWithFormat:@"%g", self.activity.efficiencyInCurrentUnits];
    self.shareLabel.text=[NSString stringWithFormat:@"%g", self.activity.sharingCount];
    self.usageSlider.value=log(self.activity.usageInCurrentUnits)*100;
    self.efficiencySlider.value=self.activity.efficiencyInCurrentUnits;
    self.shareStepper.value=self.activity.sharingCount;
    self.titleField.text=self.activity.title;
    [self updateUnits];
}

- (void)usageChanged:(UISlider *)sender {
    self.activity.usageInCurrentUnits=exp(sender.value/100);
    self.usageLabel.text=[NSString stringWithFormat:@"%g", self.activity.usageInCurrentUnits];
    [self commitEdit];
}

- (void)efficiencyChanged:(UISlider *)sender {
    self.activity.efficiencyInCurrentUnits=sender.value;
    self.efficiencyLabel.text=[NSString stringWithFormat:@"%g", self.activity.efficiencyInCurrentUnits];
    [self commitEdit];
}

- (void)shareChanged:(UIStepper *)share {
    self.activity.sharingCount=share.value;
    self.shareLabel.text=[NSString stringWithFormat:@"%g", self.activity.sharingCount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.usageSlider addTarget:self action:@selector(usageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.efficiencySlider addTarget:self action:@selector(efficiencyChanged:) forControlEvents:UIControlEventValueChanged];
    [self.shareStepper addTarget:self action:@selector(shareChanged:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.titleField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.activity.title=self.titleField.text;
    }];
    self.titleField.delegate=self;
    self.titleField.returnKeyType=UIReturnKeyDone;
    self.titleField.clearButtonMode=UITextFieldViewModeAlways;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
