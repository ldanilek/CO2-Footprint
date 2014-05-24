//
//  CFTransportViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/18/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFTransportViewController.h"
#import "CFFootprintBrain.h"
#import "CFUnitPickerViewController.h"

@interface CFTransportViewController () <UITextFieldDelegate, CFUnitPickerDelegate>

@end

@implementation CFTransportViewController

- (void)picker:(CFUnitPickerViewController *)picker pickedUnit:(NSString *)unit {
    CFValue *value = picker.valueEditing;
    if (picker.editingTop) value.topUnit=unit;
    else value.bottomUnit=unit;
    [self commitEdit];
    [self updateUnits];
}

- (void)updateUnits {
    self.efficiency.text=[NSString stringWithFormat:@"%g", self.footprint.vehicleFuelEfficiency.valueInCurrentUnits];
    self.mileage.text=[NSString stringWithFormat:@"%g", self.footprint.vehicleMileage.valueInCurrentUnits];
    [self.efficiencyTop setTitle:self.footprint.vehicleFuelEfficiency.topUnit forState:UIControlStateNormal];
    [self.efficiencyBottom setTitle:self.footprint.vehicleFuelEfficiency.bottomUnit forState:UIControlStateNormal];
    [self.mileageTop setTitle:self.footprint.vehicleMileage.topUnit forState:UIControlStateNormal];
    [self.mileageBottom setTitle:self.footprint.vehicleMileage.bottomUnit forState:UIControlStateNormal];
}

- (void)flightsChanged:(UIStepper *)sender {
    self.footprint.numberOfFlights=sender.value;
    self.numberOfFlights.text=[NSString stringWithFormat:@"%d", self.footprint.numberOfFlights];
    [self commitEdit];
}

- (void)sharingChanged:(UIStepper *)sender {
    self.footprint.carShared=sender.value;
    self.sharing.text=[NSString stringWithFormat:@"%g", self.footprint.carShared];
    [self commitEdit];
}

- (void)commitEdit {
    [[NSNotificationCenter defaultCenter] postNotificationName:FOOTPRINT_CHANGED_NOTIFICATION object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.efficiency queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.footprint.vehicleFuelEfficiency.valueInCurrentUnits=self.efficiency.text.doubleValue;
        [self commitEdit];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.mileage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.footprint.vehicleMileage.valueInCurrentUnits=self.mileage.text.doubleValue;
        [self commitEdit];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sharing.text=[NSString stringWithFormat:@"%g", self.footprint.carShared];
    self.sharingStepper.value=self.footprint.carShared;
    self.numberOfFlights.text=[NSString stringWithFormat:@"%d", self.footprint.numberOfFlights];
    self.flightsStepper.value=self.footprint.numberOfFlights;
    [self updateUnits];
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

- (IBAction)changeUnit:(id)sender {
    [self performSegueWithIdentifier:@"Pick Unit" sender:sender];
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
    if (sender==self.efficiencyTop||sender==self.efficiencyBottom) {
        picker.valueEditing=self.footprint.vehicleFuelEfficiency;
        picker.editingTop=sender==self.efficiencyTop;
    } else {
        picker.valueEditing=self.footprint.vehicleMileage;
        picker.editingTop=sender==self.mileageTop;
    }
}


@end
