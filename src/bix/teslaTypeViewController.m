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
    self.teslaType.delegate = self;
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    [self.view addSubview:myTableView];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titileString = [NSString stringWithFormat: @"section: %d, row: %d", indexPath.section, indexPath.row];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:titileString delegate:selfcancelButtonTitle:@"OK"otherButtonTitles:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertViewTest"
                                                    message:titileString
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OtherBtn",nil];
    [alert show];
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
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)saveTeslaType:(id)sender {
    NSLog(@"teslaType is %@", self.teslaType.text);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TeslaType" object:self.teslaType.text];
    
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    account.setTeslaType = self.teslaType.text;
    [account save];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
