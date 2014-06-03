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


//http://www.skepticalscience.com/human-co2-smaller-than-natural-emissions.htm
//human output is 29 gigatons of CO2 per year
//40 percent of human output is absorbed into environment
//https://answers.yahoo.com/question/index?qid=20070906124908AAXV6Bx
//1ppm = 2.348 billion tons of CO2

#define PPM_PER_TON 1./(2.348e9)

#define CURRENT_SLOPE 2.09//current slope is 209 ppm/century

#define START_CO2 397.9//in ppm. from graph on http://www.wolframalpha.com/input/?i=CO2+concentration

#define CO2_AMP 3.
//one period per year

- (double)valueForIndependent:(double)x {
    double variation = CO2_AMP*sin(x*2*M_PI);
    if (x<0) {
        //historical
        if (x<-21) {
            if (x<-39) {
                if (x<-49) {
                    if (x<-64) {
                        if (x<-99) {
                            if (x<-184) {
                                if (x<-264) {
                                    //assume constant at 275;
                                    return 275;
                                }
                                //1750
                                return linearMap(-184, 285, -264, 275)(x)+variation;
                            }
                            return linearMap(-99, 301, -184, 285)(x)+variation;
                        }
                        return linearMap(-64, 312, -99, 301)(x)+variation;
                    }
                    return linearMap(-49, 320, -64, 312)(x)+variation;
                }
                return linearMap(-39, 330, -49, 320)(x)+variation;
            }
            //less recent. hit point (-21, 358) and (-39, 330)
            return linearMap(-21, 358, -39, 330)(x)+variation;
        }
        //recent. hit point (0, start) and (-21, 358)
        return linearMap(0, START_CO2, -21, 358)(x)+variation;
    }
    
    //in tons
    double CO2DueToEverythingElsePerYear = 0;//non human emissions
    double CO2DueToHumans = self.footprint.yearlyFootprintExtrapolated;
    
    return START_CO2+(CO2DueToEverythingElsePerYear+CO2DueToHumans)*PPM_PER_TON*x+variation;
}
/*
#define START_TEMP 58.


- (double)secondValueForIndependent:(double)x {
    double variation = 0;//CO2_AMP*sin(x*2*M_PI);
    if (x<0) {
        return START_TEMP+CURRENT_SLOPE*x+variation;
    }
    
    //in tons
    double CO2DueToEverythingElsePerYear = 0;//non human emissions
    double CO2DueToHumans = self.footprint.yearlyFootprintExtrapolated;
    
    return START_CO2+(CO2DueToEverythingElsePerYear+CO2DueToHumans)*PPM_PER_TON*x+variation;
}*/

- (double)minYear {
    return -50;
}

- (double)maxYear {
    return 50;
}

- (double)minCO2 {
    //initial values
    return [self valueForIndependent:[self minYear]]-10;
}

- (double)maxCO2 {
    return [self valueForIndependent:[self maxYear]]+1;
}
/*
- (double)minTemp {
    return [self secondValueForIndependent:[self minYear]];
}

- (double)maxTemp {
    return [self secondValueForIndependent:[self maxYear]];
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    //find x from min and max year
    self.graph.scale=(self.maxYear-self.minYear)/self.graph.bounds.size.width;
    Function mapX = linearMap(self.minYear, 0, self.maxYear, self.graph.bounds.size.width);
    Function mapY = linearMap(self.minCO2, self.graph.bounds.size.height, self.maxCO2, 0);
    
    self.graph.origin=CGPointMake(mapX(0), mapY(0));
    //Function mapY2 = linearMap(self.minTemp, self.graph.bounds.size.height, self.maxTemp, 0);
    //self.graph.origin2=mapY2(0);
    
    self.graph.aspectRatio=(self.maxCO2-self.minCO2)/(self.maxYear-self.minYear);
    //self.graph.aspectRatio2=(self.maxTemp-self.minTemp)/(self.maxYear-self.minYear);
    
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
