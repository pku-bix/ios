//
//  SettingViewController.m
//  bix
//
//  Created by harttle on 14-3-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()
- (IBAction)Logout:(id)sender;
- (IBAction)Exit:(id)sender;

@end

@implementation SettingViewController

AppDelegate* appdelegate;

int action;

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
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Logout:(id)sender {
    action = 0;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认"
                                                    message:@"是否退出当前账号？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];

}

- (IBAction)Exit:(id)sender {
    action = 1;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认"
                                                    message:@"是否确认退出 Bix？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;  // 0 == the cancel button
    
    
    
    switch (action) {
        case 0:{// enable variable declares
            appdelegate.account.autoLogin = false;
            [appdelegate.account save];
            
            [self performSegueWithIdentifier:@"login" sender:self];
        
            break;
        }
        
        case 1:{
            UIApplication *app = [UIApplication sharedApplication];
            
            //home button press programmatically
            [app performSelector:@selector(suspend)];
            
            //wait 2 seconds while app is going background
            //[NSThread sleepForTimeInterval:2.0];
            
            //exit app when app is in background
            //exit(0);
            
            break;
        }
        default:
            break;
    }
    
}

@end
