//
//  CFSourcesViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 6/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFSourcesViewController.h"

#define SOURCES @[@"Wolfram Alpha", @"Mac Unit Converter Widget", @"cdiac.ornl.gov/pns/convert.html", @"epa.gov/climatechange/ghgemissions/ind-calculator.html", @"epa.gov/climatechange/ghgemissions/ind-calculator.html", @"epa.gov/climatechange/ghgemissions/ind-calculator.html", @"biomassenergycentre.org.uk/portal/page?_pageid=75,163182&_dad=portal&_schema=PORTAL", @"publicservice.vermont.gov/sites/psd/files/MAY-2014%20Fuel%20Price%20Report.pdf", @"terrapass.com/carbon-footprint-calculator-2/#air", @"terrapass.com/carbon-footprint-calculator-2/#air", @"terrapass.com/carbon-footprint-calculator-2/#air", @"epa.gov/climatechange/ghgemissions/ind-calculator.html", @"shrinkthatfootprint.com/food-carbon-footprint-diet", @"shrinkthatfootprint.com/food-carbon-footprint-diet", @"Wikipedia", @"epa.gov/climatechange/ghgemissions/ind-calculator.html"]

#define STATISTICS @[@"Unit Conversions, Historical CO2 Concentrations", @"Unit Conversions, including currency conversions as of 6/7/2014", @"1ppm in atmosphere = 2.13 metric gigatons of CO2", @"10.75 lbs of CO2 per $ of Gas", @"8.08 lbs of CO2 per $ of Oil", @"4.83 lbs of CO2 per $ of Propane", @"0.85 lbs of CO2 per kg of pellets", @"$0.27 per kg of pellets", @"0.25 tons of CO2 per short flight", @"0.63 tons of CO2 per medium flight", @"1 ton of CO2 per long flight", @"20.421053 lbs of CO2 per gallon of gasoline", @"Meat-lover: 3.3 tons, Average: 2.5 tons", @"No-Beef: 1.9 tons, Vegetarian: 1.7 tons, Vegan: 1.5 tons", @"Explanation images", @"6.42 lbs of CO2 per $ of electricity"]

@interface CFSourcesViewController () <UITableViewDataSource, UITableViewDelegate>

@property BOOL didLoad;

@end

@implementation CFSourcesViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SOURCES.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSArray *sources = SOURCES;
    NSArray *statistics = STATISTICS;
    cell.textLabel.text=sources[indexPath.row];
    cell.textLabel.minimumScaleFactor=.01;
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    cell.detailTextLabel.text=statistics[indexPath.row];
    cell.detailTextLabel.adjustsFontSizeToFitWidth=YES;
    cell.detailTextLabel.minimumScaleFactor=.01;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.didLoad) {
        UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        table.delegate=self;
        table.dataSource=self;
        [self.view addSubview:table];
        self.didLoad=YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
