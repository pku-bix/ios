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
//@property (strong, nonatomic) IBOutlet UIButton *btnAboutBix;
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
@synthesize list = _list;

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
    NSArray * array = [[NSArray alloc]initWithObjects:@"个人信息", @"上报充电桩",@"反馈与建议", @"邀请好友", nil];
    self.list = array;

    [self.btnLogout dangerStyle];
    
    [self.btnAboutBix primaryStyle];
       //AppDelegate* appdelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appdelegate.account save];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault  //cell的风格会决定下面cell.detailTextLabel.text是否有效，以及效果是怎么样的。
                    reuseIdentifier:TableSampleIdentifier];
        }
        //  cell.showsReorderControl = YES;
        
        NSUInteger row = [indexPath row];
        // NSUInteger section = [indexPath section];
        cell.textLabel.text = [self.list objectAtIndex:row];
        
        //在cell每行右边显示的风格
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        
        //    四种UITableViewCellAccessoryType:
        //    UITableViewCellAccessoryNone,
        //    UITableViewCellAccessoryDisclosureIndicator,
        //    UITableViewCellAccessoryDetailDisclosureButton,
        //    UITableViewCellAccessoryCheckmark,
        //    UITableViewCellAccessoryDetailButton
        
        
        ////    cell.detailTextLabel.text = @"i am tian cai";
    UIImage *image0 = [UIImage imageNamed:@"personInfo"];
    UIImage *image1 = [UIImage imageNamed:@"share"];
    UIImage *image2 = [UIImage imageNamed:@"reported"];
    UIImage *image3 = [UIImage imageNamed:@"invite"];
        //    //图片显示在cell的左边
    switch (row) {
        case 0:
            cell.imageView.image = image0;
            break;
        case 1:
            cell.imageView.image = image1;
            break;
        case 2:
            cell.imageView.image = image2;
            break;
        case 3:
            cell.imageView.image = image3;
            break;
            
        default:
            break;
    }
        //    UIImage *highLighedImage = [UIImage imageNamed:@"geo_fence-32"];
        //    cell.imageView.highlightedImage = highLighedImage;
        //
    cell.detailTextLabel.text = @"asdfasdf";
        
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowString = [self.list objectAtIndex:[indexPath row]];
    //    id sectionNumber = [self.list objectAtIndex:[indexPath section]];
    //    rowString = rowString + [[indexPath section] ];
    //    rowString = @"rowString" + @"hhh";
    NSLog(@"你选中了第%d section 第 %d row", [indexPath section], indexPath.row);
    if(indexPath.row == 0)
    {
        aboutViewController * about = [[aboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
        [about  viewDidLoad];
        about.title = @"关于";
    }
    else
    {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的section和行信息" message:rowString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        // NSLog(sectionNumber);
        [alter show];
        
    }

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
//
//- (IBAction)aboutBix:(id)sender {
//}
@end
