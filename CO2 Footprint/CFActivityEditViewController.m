//
//  CFActivityEditViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/9/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFActivityEditViewController.h"
#import "CFFootprintBrain.h"

@interface CFActivityEditViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.picker selectRow:self.activity.subtype inComponent:0 animated:NO];
    self.usageLabel.text=[NSString stringWithFormat:@"%g", self.activity.usage];
    self.shareLabel.text=[NSString stringWithFormat:@"%g", self.activity.sharingCount];
    self.usageSlider.value=log(self.activity.usage)*100;
    self.shareStepper.value=self.activity.sharingCount;
    self.titleField.text=self.activity.title;
}

- (void)usageChanged:(UISlider *)sender {
    self.activity.usage=exp(sender.value/100);
    self.usageLabel.text=[NSString stringWithFormat:@"%g", self.activity.usage];
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
    [self.shareStepper addTarget:self action:@selector(shareChanged:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.titleField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.activity.title=self.titleField.text;
    }];
    self.titleField.delegate=self;
    self.titleField.returnKeyType=UIReturnKeyDone;
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
