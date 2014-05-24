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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
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
    // Do any additional setup after loading the view.
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
