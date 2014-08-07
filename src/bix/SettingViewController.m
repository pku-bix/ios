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
#import "Constants.h"
#import "aboutViewController.h"


@interface SettingViewController ()
- (IBAction)Logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) IBOutlet UIButton *btnAboutBix;

@end

@implementation SettingViewController
{
    /*CGRect rect;
    UITextView *_textView;
    UITextView *_textViewTitle;
    NSString *aboutApp;
    */
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

    [self.btnLogout dangerStyle];
    
    [self.btnAboutBix primaryStyle];
       //AppDelegate* appdelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appdelegate.account save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Logout:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认"
                                                    message:@"是否退出当前账号？"
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
    [appdelegate logOut];
}


- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogOut:)
                                             name:EVENT_DISCONNECTED object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DISCONNECTED object:NULL];
}

-(void) didLogOut: (NSNotification*) notification{
    
    AppDelegate* appdelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //释放代理
    [appdelegate.xmppStream removeDelegate:appdelegate.xmppDelegate];
    
    //保存账号
    appdelegate.account.autoLogin = false;
    [appdelegate.account save];
    
    [self performSegueWithIdentifier:@"login" sender:self];
}

- (IBAction)aboutBix:(id)sender {
    aboutViewController *aboutBix = [[aboutViewController alloc]init];
    [self.navigationController pushViewController:aboutBix animated:YES];
    aboutBix.title = @"关于";
    
}

@end
