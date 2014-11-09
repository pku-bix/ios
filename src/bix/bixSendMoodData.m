//
//  bixSendMoodData.m
//  bix
//
//  Created by dsx on 14-11-4.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixSendMoodData.h"

@interface bixSendMoodData ()

@end

@implementation bixSendMoodData
{
    UIImage *pickImage;
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
    
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.image1.image = self.image;
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

#pragma PassImageDelegate

-(void)passImage:(UIImage *)image
{
    pickImage = image;
}


- (IBAction)cancleSendMood:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMood:(id)sender {
    
}
@end
