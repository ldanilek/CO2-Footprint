//
//  CFExtrapolationViewController.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/28/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFGraphView.h"
#import "CFFootprintBrain.h"

//this looks important http://www.esrl.noaa.gov/gmd/ccgg/trends/
//sinusoidal graph of CO2 concentration?

@interface CFExtrapolationViewController : UIViewController

@property (nonatomic, weak) IBOutlet CFGraphView *graph;
@property (weak) CFFootprintBrain *footprint;

@end
