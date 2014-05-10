//
//  CFUnitPickerViewController.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/10/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFUnitPickerViewController;
@protocol CFUnitPickerDelegate <NSObject>

- (void)picker:(CFUnitPickerViewController *)picker pickedUnit:(NSString *)unit;

@end

@interface CFUnitPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, atomic) NSArray *possibilities;//set before willAppear
@property (atomic) int startingIndex;//picker should start on the current unit
@property (weak, atomic) id <CFUnitPickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (atomic) int unitIndex;

@end
