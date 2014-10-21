//
//  reportMapViewController.m
//  bix
//
//  Created by dsx on 14-10-21.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "reportMapViewController.h"

@interface reportMapViewController ()

@end

@implementation reportMapViewController
{
    CGRect rect;
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
    rect = [[UIScreen mainScreen]bounds];
    reportMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
//
    [self.view addSubview:reportMapView];
    [self.view addSubview:btnReportCharger];
}

-(void)locateCurrentPosition
{
    reportMapView.showsUserLocation = NO;
    reportMapView.userTrackingMode = BMKUserTrackingModeFollow;
    reportMapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [reportMapView viewWillAppear];
    reportMapView.delegate = self;
    [self locateCurrentPosition];
//    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [reportMapView viewWillDisappear];
    reportMapView.delegate = nil;
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

- (IBAction)nextStep:(id)sender {
    [self performSegueWithIdentifier:@"reportCharger" sender:self];
}
@end
