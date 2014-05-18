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

@end
