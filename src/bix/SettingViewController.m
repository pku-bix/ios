//
//  SettingViewController.m
//  bix
//
//  Created by harttle on 14-3-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
//#import "UIButton+Bootstrap.h"
#import "Constants.h"
#import "aboutViewController.h"
#import "generalTableView.h"

@interface SettingViewController ()
//- (IBAction)Logout:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end

@implementation SettingViewController
{
    CGRect rect;
    UITableView *tableView0;
    generalTableView *generalTableView0;
}

//@synthesize list = _list;
//@synthesize list2 = _list2;

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
    
    generalTableView0 = [[generalTableView alloc]init];
    
    NSArray * array = [[NSArray alloc]initWithObjects:@"个人信息", @"上报充电桩",@"反馈与建议", @"邀请好友", nil];
    NSArray * array2 = [[NSArray alloc]initWithObjects:@"关于Bix", @"支持我们", @"退出登录", nil];
    
//    self.list = array;
//    self.list2 = array2;
    
    generalTableView0.list = array;
    generalTableView0.list2 = array2;
    
    //用代码来创建 tableview
     tableView0 =[[UITableView alloc]initWithFrame:CGRectMake(0, 50, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView0];

    //[self.btnLogout dangerStyle];
    //[self.btnAboutBix primaryStyle];
    
    //AppDelegate* appdelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appdelegate.account save];
}

#pragma mark dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [generalTableView0 numberOfSectionsInTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [generalTableView0 numberOfRowsInSection:section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [generalTableView0 tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [generalTableView0 titleForHeaderInSection:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [generalTableView0 titleForFooterInSection:section];
}


#pragma mark delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [generalTableView0 didSelectRowAtIndexPath:indexPath setingViewController:self];
    
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //设置 dataSource 和 delegate 这两个代理
    tableView0.delegate = self;
    tableView0.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DISCONNECTED object:NULL];
    //不用时，置nil
    tableView0.delegate = nil;
    tableView0.dataSource = nil;
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

@end
