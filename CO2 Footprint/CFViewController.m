//
//  CFViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/7/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFViewController.h"
#import "CFFootprintBrain.h"
#import "CFActivityEditViewController.h"

@interface CFViewController () <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) CFFootprintBrain *brain;
@property (nonatomic, strong) NSArray *tableViews;//could be one table view. use mostly for reloading

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

//if only one table, types are represented by sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self multipleTables]) {
        return 1;
    } else {
        return typeCount();
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityType type = [self multipleTables] ? tableView.tag : [self.brain activityTypeAtIndex:indexPath.section];
    return indexPath.row!=[self.brain activityCountOfType:type];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        ActivityType type = [self multipleTables] ? tableView.tag : [self.brain activityTypeAtIndex:indexPath.section];
        [self.brain deleteActivityAtIndex:indexPath.row withType:type];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[NSNotificationCenter defaultCenter] postNotificationName:FOOTPRINT_CHANGED_NOTIFICATION object:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (![self multipleTables]) {
        ActivityType type = [self.brain activityTypeAtIndex:section];
        return stringForType(type);
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self multipleTables]) {
        //tables identified by tag
        return [self.brain activityCountOfType:tableView.tag]+1;
    } else {
        //type identified by section
        return [self.brain activityCountOfType:section]+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    ActivityType type;
    if ([self multipleTables]) {
        type = tableView.tag;
    } else {
        type = [self.brain activityTypeAtIndex:indexPath.section];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==[self.brain activityCountOfType:type]) {
        cell.textLabel.text=[@"New " stringByAppendingString:stringForType(type)];
    } else {
        cell.textLabel.text=[self.brain activityDisplayAtIndex:indexPath.row forType:type];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityType type = [self multipleTables] ? tableView.tag : [self.brain activityTypeAtIndex:indexPath.section];
    if (indexPath.row==[self.brain activityCountOfType:type]) {
        CFActivity *newActivity = [self.brain newActivityWithType:type];
        [[NSNotificationCenter defaultCenter] postNotificationName:FOOTPRINT_CHANGED_NOTIFICATION object:nil];
        [self editActivity:newActivity tableView:tableView indexPath:indexPath];
    } else {
        [self editActivity:[self.brain activityAtIndex:indexPath.row withType:type] tableView:tableView indexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popover=nil;
    for (UITableView *tableView in self.tableViews) {
        [tableView reloadData];
    }
}

//moves to a new view controller to edit.
//if in iPad, present from popover from cell
- (void)editActivity:(CFActivity *)activity tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    if ([self multipleTables]) {
        CFActivityEditViewController *editor = [[self storyboard] instantiateViewControllerWithIdentifier:@"Edit Activity"];
        editor.activity=activity;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:editor];
        CGRect rect = [tableView cellForRowAtIndexPath:indexPath].frame;
        [self.popover presentPopoverFromRect:rect inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.popover.delegate=self;
    } else {
        [self performSegueWithIdentifier:@"Edit Activity" sender:activity];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController respondsToSelector:@selector(setActivity:)]) {
        [(CFActivityEditViewController *)segue.destinationViewController setActivity:sender];
    }
}

//when I have a bigger screen, I can line up the tables horizontally
- (BOOL)multipleTables {
    return UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UITableView *tableView in self.tableViews) {
        [tableView reloadData];
    }
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
        
        //set up a table for each activity type
        if ([self multipleTables]) {
            CGFloat tableWidth = self.view.bounds.size.width/typeCount();
            CGFloat tableX = 0;
            CGFloat tableY = 300;
            CGFloat tableHeight = self.view.bounds.size.height-tableY;
            NSMutableArray *tableViews = [NSMutableArray array];
            for (ActivityType type=0; type<typeCount(); type++) {
                UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableWidth, tableHeight) style:UITableViewStylePlain];
                table.delegate=self;
                table.dataSource=self;
                table.tag=[self.brain activityTypeAtIndex:type];
                [self.view addSubview:table];
                [tableViews addObject:table];
                
                tableX+=tableWidth;
            }
            self.tableViews=[tableViews copy];
        } else {
            CGFloat tableY = 100;
            CGFloat tableHeight = self.view.bounds.size.height-tableY;
            UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, self.view.bounds.size.width, tableHeight) style:UITableViewStylePlain];
            table.delegate=self;
            table.dataSource=self;
            [self.view addSubview:table];
            self.tableViews=@[table];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
