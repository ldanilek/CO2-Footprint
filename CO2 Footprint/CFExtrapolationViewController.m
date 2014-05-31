//
//  CFExtrapolationViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/28/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFExtrapolationViewController.h"

@interface CFExtrapolationViewController () <CFGraphDelegate>

@end

@implementation CFExtrapolationViewController

#define PPM_PER_TON .0000000001

- (double)valueForIndependent:(double)x {
    if (x<0) {
        return nan("negative time");
    }
    double currentCO2 = 350;//in ppm
    
    //in tons
    double CO2DueToEverythingElsePerYear = 50;//non human emissions
    double CO2DueToHumans = self.footprint.yearlyFootprintExtrapolated;
    
    return currentCO2+(CO2DueToEverythingElsePerYear+CO2DueToHumans)*PPM_PER_TON*x;
}

- (double)secondValueForIndependent:(double)x {
    if (x<0) {
        return nan("hey");
    }
    return log(x);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.graph.origin=CGPointMake(self.graph.bounds.size.width/2, self.graph.bounds.size.height/2);
    self.graph.scale=.01;
    self.graph.aspectRatio=1;
    self.graph.delegate=self;
    [self.graph setupGestures];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
