//
//  SettingViewController.m
//  bix
//
//  Created by harttle on 14-3-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "UIButton+Bootstrap.h"

@interface SettingViewController ()
- (IBAction)Logout:(id)sender;
- (IBAction)Clear:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@end

@implementation SettingViewController



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

    [self.btnLogout dangerStyle];
    
    //AppDelegate* appdelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appdelegate.account save];
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

- (IBAction)Clear:(id)sender {
    action = 1;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认"
                                                    message:@"将会清除当前用户所有信息，包括联系人、会话记录"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // cancel
    if (buttonIndex == 0) return;
    
    AppDelegate* appdelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;

    switch (action) {
        case 0:
            appdelegate.account.autoLogin = false;
            
            [appdelegate.account save];
            [self performSegueWithIdentifier:@"login" sender:self];
            
            
            //UIApplication *app = [UIApplication sharedApplication];
            
            //home button press programmatically
            //[app performSelector:@selector(suspend)];
            
            //wait 2 seconds while app is going background
            //[NSThread sleepForTimeInterval:2.0];
            
            //exit app when app is in background
            //exit(0);
            break;
        case 1:
            [appdelegate.account clearAll];
            [appdelegate.account save];
            break;
        default:
            break;
    }
    
}

@end
