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
//- (IBAction)Logout:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
//@property (strong, nonatomic) IBOutlet UIButton *btnAboutBix;

@end

@implementation SettingViewController
{
    CGRect rect;
    UITableView *tableView0;
}

@synthesize list = _list;
@synthesize list2 = _list2;

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
    
    NSArray * array = [[NSArray alloc]initWithObjects:@"个人信息", @"上报充电桩",@"反馈与建议", @"邀请好友", nil];
    NSArray * array2 = [[NSArray alloc]initWithObjects:@"关于Bix", @"支持我们", @"退出登录", nil];
    
    self.list = array;
    self.list2 = array2;
//    UITableView *tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //用代码来创建 tableview
     tableView0 =[[UITableView alloc]initWithFrame:CGRectMake(0, 50, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];

    //设置 dataSource 和 delegate 这两个代理
    tableView0.dataSource = self;
    tableView0.delegate = self;
    
    [self.view addSubview:tableView0];

    //[self.btnLogout dangerStyle];
    //[self.btnAboutBix primaryStyle];
    
    //AppDelegate* appdelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appdelegate.account save];
}

//#pragma mark dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [self.list count];
    }
    else
    {
        return [self.list2 count];
    }
    
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
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [self.list objectAtIndex:row];
    }
    else
    {
        cell.textLabel.text = [self.list2 objectAtIndex:row];
    }
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
     //图片显示在cell的左边， 不同cell， 显示的图片不同；
    
    switch (row) {
        case 0:
            cell.imageView.image = image0;
            break;
        case 1:
            cell.imageView.image = image1;
            //设置tableview cell 的背景颜色；
          //  cell.contentView.backgroundColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.1 alpha:1];
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
        //    cell.detailTextLabel.text = @"asdfasdf";
    
    //cell 被选中后颜色不变， 不会变暗！！
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    typedef enum : NSInteger {
//        UITableViewCellSelectionStyleNone,
//        UITableViewCellSelectionStyleBlue,
//        UITableViewCellSelectionStyleGray,
//        UITableViewCellSelectionStyleDefault
//    } UITableViewCellSelectionStyle;
    
    
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *rowString = [self.list objectAtIndex:[indexPath row]];
    //    id sectionNumber = [self.list objectAtIndex:[indexPath section]];
    //    rowString = rowString + [[indexPath section] ];
    //    rowString = @"rowString" + @"hhh";
    NSLog(@"你选中了第%d section 第 %d row", [indexPath section], indexPath.row);
   
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
           
        }
        else if(indexPath.row == 3)
        {
            //  UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的section和行信息" message:rowString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //        // NSLog(sectionNumber);
            //        [alter show];
            
        }
    }
    else  //section = 1;
    {
        if(indexPath.row == 0)
        {
            aboutViewController * about = [[aboutViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
            [about  viewDidLoad];
            about.title = @"关于";
        }
        else if(indexPath.row == 2)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认"
                                                            message:@"是否退出当前账号？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    //[self.ta]
    

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"页眉0";
    }
    else
    {
        return @"页眉1";
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"页脚0";
    }
    else
    {
        return @"页脚1";
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (IBAction)Logout:(id)sender {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认"
//                                                    message:@"是否退出当前账号？"
//                                                   delegate:self
//                                          cancelButtonTitle:@"取消"
//                                          otherButtonTitles:@"确定", nil];
//    [alert show];
//
//}

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

@end
