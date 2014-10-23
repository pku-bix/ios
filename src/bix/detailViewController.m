//
//  detailViewController.m
//  bix
//
//  Created by dsx on 14-10-1.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "detailViewController.h"
#import "Constants.h"

@interface detailViewController ()

@end

@implementation detailViewController


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
    NSLog(@"viewDidLoad");
//     _textView.font = [UIFont systemFontOfSize:15];
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

-(void)viewWillAppear:(BOOL)animated
{
    self.chargerAddress.text = self.detailAddress;
    self.chargerAddress.font = [UIFont systemFontOfSize:16];
    self.chargerAddress.selectable = NO;
    self.chargerAddress.editable = NO;
    self.chargerAddress.scrollEnabled = NO;
    
    self.chargerType.text = self.type;
    self.chargerParkingnum.text = self.parkingnum;
    self.chargerInfo.text = self.info;
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
