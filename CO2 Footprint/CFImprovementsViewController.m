//
//  CFImprovementsViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/28/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFImprovementsViewController.h"

@interface CFImprovementsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *keywords;
@property (nonatomic, strong) NSArray *sectionTitles;

@end

@implementation CFImprovementsViewController

- (NSDictionary *)keywords {
    if (!_keywords) {
        NSMutableDictionary *dict = [@{} mutableCopy];
        for (NSString *sectionTitle in self.sectionTitles) {
            dict[sectionTitle]=[self.footprint keywordsForSectionTitle:sectionTitle];
        }
        _keywords=[dict copy];
    }
    return _keywords;
}

- (NSArray *)sectionTitles {
    if (!_sectionTitles) {
        NSMutableArray *arry = [@[] mutableCopy];
        for (NSString *sectionTitle in @[@"Home", @"Transportation", @"Diet"]) {
            NSArray *keywds = [self.footprint keywordsForSectionTitle:sectionTitle];
            if (keywds.count) {
                [arry addObject:sectionTitle];
            }
        }
        _sectionTitles=[arry copy];
    }
    return _sectionTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.keywords[self.sectionTitles[section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"he"];
    NSString *keyword =self.keywords[self.sectionTitles[indexPath.section]][indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@: %@", keyword, [self.footprint explanationForKeyword:keyword]];
    CFValue *converter = [[CFValue alloc] initWithUnitsTop:UnitMass bottom:UnitTime];
    converter.bottomUnit=@"yr";
    converter.value=[self.footprint savingsForKeyword:keyword];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"Save %g tons of emissions per year", converter.valueInCurrentUnits];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
    // Do any additional setup after loading the view.
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
