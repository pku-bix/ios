//
//  detailViewController.m
//  bix
//
//  Created by dsx on 14-10-1.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixDetailViewController.h"
#import "Constants.h"
#import "bixSuperCharger.h"
#import "bixHomeCharger.h"
#import "bixDestCharger.h"

@interface bixDetailViewController ()

@end

@implementation bixDetailViewController
{
    UITableView *chargerDetailTableView;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    chargerDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    chargerDetailTableView.backgroundColor = [UIColor clearColor];
    
    NSLog(@"%f, %f", self.view.bounds.size.width, self.view.bounds.size.height);
    
    chargerDetailTableView.delegate = self;
    chargerDetailTableView.dataSource = self;
    
    [self.view addSubview:chargerDetailTableView];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    navigationBar.translucent = YES;
    //    [navigationBar setBackgroundColor:[UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:1]];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setTitle:@"充电桩信息"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(back2Map)];
    [navigationItem setLeftBarButtonItem:leftButton];
    
    [self.view addSubview:navigationBar];
    
//    self.chargerAddress.font = [UIFont systemFontOfSize:16];
//    self.chargerAddress.selectable = NO;
//    self.chargerAddress.editable = NO;
//    self.chargerAddress.scrollEnabled = NO;
//    
    self.charger.observer = self;
    [self.charger pull];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"充电桩类型";
            break;
        case 1:
            return @"地址";
            break;
        case 2:
            return @"充电位";
            break;
        default:
            return @"信息";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell For Row At Index Path");
    static NSString *cellIndetifer = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifer];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifer];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[self.charger class] description];
//            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"super_charger_label.png"]];
            break;
        case 1:
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = self.charger.address;
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%d", self.charger.parkingnum ];
            break;
        case 3:
            cell.textLabel.text = [self chargerInfoString];
            break;
    }
    NSLog(@"%f", cell.backgroundView.frame.size.width);
    cell.selectionStyle = NO;
    
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 64.0;
    }
    else
        return 48.0;
}

-(void)modelUpdated:(id)model{
    NSLog(@"Model Update");
//    self.chargerType.text = [[self.charger class] description];
//    self.chargerParkingnum.text = [NSString stringWithFormat:@"%d", self.charger.parkingnum ];
//    self.chargerAddress.text =self.charger.address;
//    self.chargerInfo.text = [self chargerInfoString];
    [chargerDetailTableView reloadData];
}

-(NSString*) chargerInfoString{
    if ([self.charger isKindOfClass:[bixDestCharger class]]) {
        bixDestCharger* c = (bixDestCharger*)self.charger;
        
        return c.comment;
    }
    else if ([self.charger isKindOfClass:[bixSuperCharger class]]){
        bixSuperCharger* c=(bixSuperCharger*)self.charger;
        
        return c.hours;
    }
    return nil;
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

-(void)back2Map
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
