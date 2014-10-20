//
//  weChatIDViewController.m
//  bix
//
//  Created by dsx on 14-10-20.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "weChatIDViewController.h"
#import "AppDelegate.h"

@interface weChatIDViewController ()

@end

@implementation weChatIDViewController

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

- (IBAction)weChatID:(id)sender {
    NSLog(@"weChatIDChange is %@", self.weChatID.text);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"WechatID" object:self.weChatID.text];
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    account.setWechatID = self.weChatID.text;
    [account save];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
