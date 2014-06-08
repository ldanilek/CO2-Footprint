//
//  CFExtrapolationViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/28/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CFExtrapolationViewController.h"

@interface CFExtrapolationViewController () <CFGraphDelegate>

@property (nonatomic) double ppmPerYear;//since the footprint will not change over the life of the extrapolation view controller, it's safe to calculate the slope once and reuse it.
@property BOOL loaded;

@end

@implementation CFExtrapolationViewController

//http://www.skepticalscience.com/human-co2-smaller-than-natural-emissions.htm
//human output is 29 gigatons of CO2 per year
//40 percent of human output is absorbed into environment
//https://answers.yahoo.com/question/index?qid=20070906124908AAXV6Bx
//1ppm = 2.348 billion tons of CO2
//according to http://cdiac.ornl.gov/pns/convert.html
//1ppm = 2.13 metric gigatons
//1ppm = 2.348*10^9 short tons
#define PPM_PER_TON 1./(2.348e9)

#define CURRENT_SLOPE 2.09//current slope is 209 ppm/century

#define START_CO2 397.9//in ppm. from graph on http://www.wolframalpha.com/input/?i=CO2+concentration

#define CO2_AMP 3.
//one period per year


- (double)ppmPerYear {
    if (!_ppmPerYear) {
        //in tons
        double CO2DueToEverythingElsePerYear = 0;//non human emissions
        double CO2DueToHumans = self.footprint.yearlyFootprintExtrapolated;
        _ppmPerYear = (CO2DueToEverythingElsePerYear+CO2DueToHumans)*PPM_PER_TON;
    }
    return _ppmPerYear;
}

- (double)valueForIndependent:(double)x {
    double variation = CO2_AMP*sin(x*2*M_PI);
    if (x<0) {
        //historical
        //store for easy access and efficiency of calculation
        static Function between414and464;
        if (!between414and464) between414and464 = linearMap(-414, 275, -464, 282);
        static Function between264and414;
        if (!between264and414) between264and414 = linearMap(-264, 275, -414, 275);
        static Function between184and264;
        if (!between184and264) between184and264 = linearMap(-184, 285, -264, 275);
        static Function between99and184;
        if (!between99and184) between99and184 = linearMap(-99, 301, -184, 285);
        static Function between64and99;
        if (!between64and99) between64and99 = linearMap(-64, 312, -99, 301);
        static Function between49and64;
        if (!between49and64) between49and64 = linearMap(-49, 320, -64, 312);
        static Function between39and49;
        if (!between39and49) between39and49 = linearMap(-39, 330, -49, 320);
        static Function between21and39;
        if (!between21and39) between21and39 = linearMap(-21, 358, -39, 330);
        static Function between19and21;
        if (!between19and21) between19and21 = linearMap(-19, 360, -21, 358);
        static Function between6and19;
        if (!between6and19) between6and19 = linearMap(-6, 385, -19, 360);
        static Function between0and6;
        if (!between0and6) between0and6 = linearMap(0, START_CO2, -6, 385);
        
        if (x<-6) {
            if (x<-19) {
                if (x<-21) {
                    if (x<-39) {
                        if (x<-49) {
                            if (x<-64) {
                                if (x<-99) {
                                    if (x<-184) {
                                        if (x<-264) {
                                            if (x<-414) {
                                                if (x<-464) {
                                                    return 282+variation;
                                                }
                                                return between414and464(x)+variation;
                                            }
                                            return between264and414(x)+variation;
                                        }
                                        //1750
                                        return between184and264(x)+variation;
                                    }
                                    return between99and184(x)+variation;
                                }
                                return between64and99(x)+variation;
                            }
                            return between49and64(x)+variation;
                        }
                        return between39and49(x)+variation;
                    }
                    //less recent. hit point (-21, 358) and (-39, 330)
                    return between21and39(x)+variation;
                }
                return between19and21(x)+variation;
            }
            return between6and19(x)+variation;
        }
        return between0and6(x)+variation;
    }
    
    return START_CO2+self.ppmPerYear*x+variation;
}

- (double)minYear {
    return -50;
}

- (double)maxYear {
    return 50;
}

- (double)minCO2 {
    //initial values
    return [self valueForIndependent:[self minYear]];
}

- (double)maxCO2 {
    return [self valueForIndependent:[self maxYear]];
}
- (void)viewDidLayoutSubviews {
    if (!self.loaded) {
        self.loaded=YES;
        //find x from min and max year
        double yearDistance = (self.maxYear-self.minYear);
        double co2Distance = (self.maxCO2-self.minCO2);
        self.graph.scale=yearDistance/self.graph.bounds.size.width;
        Function mapX = linearMap(self.minYear, 0, self.maxYear, self.graph.bounds.size.width);
        Function mapY = linearMap(self.minCO2, self.graph.bounds.size.height, self.maxCO2, 0);
        
        self.graph.origin=CGPointMake(mapX(0), mapY(0));
        
        self.graph.aspectRatio=(co2Distance/self.graph.bounds.size.height)/(yearDistance/self.graph.bounds.size.width);
        
        self.graph.delegate=self;
        [self.graph setupGestures];
        self.graph.layer.cornerRadius=20;
        self.graph.layer.borderColor=[[UIColor blackColor] CGColor];
        self.graph.layer.borderWidth=2;
        self.graph.clipsToBounds=YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
