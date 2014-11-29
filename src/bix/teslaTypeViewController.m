//
//  teslaTypeViewController.m
//  bix
//
//  Created by dsx on 14-10-20.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "teslaTypeViewController.h"
#import "AppDelegate.h"

@interface teslaTypeViewController ()

@end

@implementation teslaTypeViewController
{
    UITableView *myTableView;
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
    // Do any additional setup after loading the view.
    //self.teslaType.delegate = self;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    }
    else
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
//    myTableView.allowsSelection = YES;
    [self.view addSubview:myTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    myTableView.delegate = self;
    myTableView.dataSource = self;

}

-(void)viewWillDisappear:(BOOL)animated
{
    myTableView.delegate = nil;
    myTableView.dataSource = nil;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"MODEL S";
            break;
        case 1:
            return @"MODEL X";
        default:
            return @"ROADSTER";
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIndetifer = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifer];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifer];
    }
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"60";
            }
            else if(indexPath.row == 1){
                cell.textLabel.text = @"85";
            }
            else
                cell.textLabel.text = @"P85D";
            
            break;
        case 1:
            cell.textLabel.text = @"MODEL X";
            break;
        case 2:
            cell.textLabel.text = @"ROADSTER";
            break;
    }
    
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hehe nimei");
    NSString *titileString = [NSString stringWithFormat: @"section: %d, row: %d", indexPath.section, indexPath.row];
    NSLog(titileString, nil);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tap TableView");
    NSString *titileString = [NSString stringWithFormat: @"section: %d, row: %d", indexPath.section, indexPath.row];
    NSLog(titileString, nil);
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
