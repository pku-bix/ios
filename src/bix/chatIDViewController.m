//
//  chatIDViewController.m
//  bix
//
//  Created by dsx on 14-10-20.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "chatIDViewController.h"
#import "AppDelegate.h"

@interface chatIDViewController ()

@end

@implementation chatIDViewController

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

- (IBAction)saveID:(id)sender {
    NSLog(@"IDChange is %@", self.IDChange.text);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IDChange" object:self.IDChange.text];
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    account.setID = self.IDChange.text;
    [account save];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
