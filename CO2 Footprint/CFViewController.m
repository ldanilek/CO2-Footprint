//
//  CFViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFViewController.h"
#import "CFFootprintBrain.h"
#import "CFHomeViewController.h"
#import "CFTransportViewController.h"
#import "CFDietViewController.h"

@interface CFViewController () <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) CFFootprintBrain *brain;
@property (nonatomic, weak) UITableView *tableView;//could be one table view. use mostly for reloading

@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation CFViewController

#define FOOTPRINT_BRAIN_STORAGE_KEY @"Key for storing the main CO2 footprint brain in NSUserDefaults"
- (CFFootprintBrain *)brain {
    if (!_brain) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FOOTPRINT_BRAIN_STORAGE_KEY];
        if (data) _brain=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!_brain) {
            _brain=[[CFFootprintBrain alloc] init];
        }
    }
    return _brain;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//About Table View
//just one table view, even on iPad
//no rows are editable or deletable

//Output section
//Carbon Footprint label
//Explanation
//Extrapolation
//Lifestyle changes

//Input section
//Home
//Transportation
//Diet

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"Output", @"Input"][section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {//inputs
        return 3;
    } else {//outputs
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section) {//inputs
        cell.textLabel.text=@[@"Home", @"Transportation", @"Diet"][indexPath.row];
        if (![self usePopovers]) cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    } else {
        //outputs
        if (indexPath.row) {
            cell.textLabel.text=@[@"",@"Explanation", @"Extrapolation", @"Improvements", @"Sources and Statistics"][indexPath.row];
            if (![self usePopovers]) cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        } else {
            //CO2 Footprint
            CFValue *footprint = [[CFValue alloc] initWithUnitsTop:UnitVolume bottom:UnitTime];
            footprint.bottomUnit=@"yr";
            footprint.value=self.brain.footprint;
            cell.textLabel.text=[NSString stringWithFormat:@"Footprint: %g tons/year", footprint.valueInCurrentUnits];
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row||indexPath.section;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        [self editFromTableView:tableView indexPath:indexPath];
    } else {
        NSString *identifier = @"Explanation";
        if (indexPath.row==2) {
            identifier=@"Extrapolation";
        } else if (indexPath.row==3) {
            identifier=@"Improvements";
        } else if (indexPath.row==4) {
            identifier=@"Sources and Statistics";
        }
        if ([self usePopovers]) {
            [self presentViewInPopover:identifier fromTableView:tableView indexPath:indexPath];
        } else {
            [self performSegueWithIdentifier:identifier sender:indexPath];
        }
    }
    if (![self usePopovers])[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popover=nil;
    [self.tableView reloadData];
}

//moves to a new view controller to edit.
//if in iPad, present from popover from cell
- (void)editFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Edit Home";
    if (indexPath.row==1) {
        identifier=@"Edit Transport";
    } else if (indexPath.row==2) {
        identifier=@"Edit Diet";
    }
    if ([self usePopovers]) {
        [self presentViewInPopover:identifier fromTableView:tableView indexPath:indexPath];
    } else {
        [self performSegueWithIdentifier:identifier sender:indexPath];
    }
}

- (void)presentViewInPopover:(NSString *)storyboardId fromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = [[self storyboard] instantiateViewControllerWithIdentifier:storyboardId];
    if ([viewController respondsToSelector:@selector(setFootprint:)]) {
        [(id)viewController setFootprint:self.brain];
    }
    self.popover = [[UIPopoverController alloc] initWithContentViewController:viewController];
    CGRect rect = [tableView cellForRowAtIndexPath:indexPath].frame;
    [self.popover presentPopoverFromRect:rect inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.popover.delegate=self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController respondsToSelector:@selector(setFootprint:)]) {
        [(id)segue.destinationViewController setFootprint:self.brain];
    }
}

//when I have an iPad, I can use popovers to present and edit information
- (BOOL)usePopovers {
    return UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //respond to notifications
    [[NSNotificationCenter defaultCenter] addObserverForName:FOOTPRINT_CHANGED_NOTIFICATION object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.brain] forKey:FOOTPRINT_BRAIN_STORAGE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

- (void)viewDidLayoutSubviews {
    static BOOL loaded = NO;
    if (!loaded) {
        loaded=YES;
        CGFloat tableY = 0;
        CGFloat tableHeight = self.view.bounds.size.height-tableY;
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, self.view.bounds.size.width, tableHeight) style:UITableViewStyleGrouped];
        table.delegate=self;
        table.dataSource=self;
        [self.view addSubview:table];
        self.tableView=table;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
