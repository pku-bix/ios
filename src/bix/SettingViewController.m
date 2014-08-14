//
//  SettingViewController.m
//  bix
//
//  implemented by dsx
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
    UITableView *table_View;
    generalTableView *general_TableView;
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
    
    general_TableView = [[generalTableView alloc]init];
    
    NSArray * array = [[NSArray alloc]initWithObjects:@"个人信息", @"上报充电桩",@"反馈与建议", @"邀请好友", nil];
    NSArray * array2 = [[NSArray alloc]initWithObjects:@"关于Bix", @"支持我们", @"退出登录", nil];
    
//    self.list = array;
//    self.list2 = array2;
    
    general_TableView.list = array;
    general_TableView.list2 = array2;
    
    //用代码来创建 tableview
     table_View =[[UITableView alloc]initWithFrame:CGRectMake(0, 50, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:table_View];

    //[self.btnLogout dangerStyle];
    //[self.btnAboutBix primaryStyle];
    
    //AppDelegate* appdelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appdelegate.account save];
}

#pragma mark dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [general_TableView numberOfSectionsInTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [general_TableView numberOfRowsInSection:section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [general_TableView tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [general_TableView titleForHeaderInSection:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [general_TableView titleForFooterInSection:section];
}


#pragma mark delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [general_TableView didSelectRowAtIndexPath:indexPath setingViewController:self];
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
    table_View.delegate = self;
    table_View.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DISCONNECTED object:NULL];
    //不用时，置nil
    table_View.delegate = nil;
    table_View.dataSource = nil;
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
