//
//  chargerInfoViewController.m
//  bix
//
//  Created by dsx on 14-10-23.
//  Copyright (c) 2014年 bix. All rights reserved.
//
#import "chargerInfoViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "UIButton+Bootstrap.h"
#import "MessageBox.h"
//#import "RequestInfoFromServer.h"

@interface chargerInfoViewController ()

@end

@implementation chargerInfoViewController
{
    AppDelegate * appDelegate;
//    RequestInfoFromServer *request;
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
    [self.btnSubmitReport primaryStyle];
    
   //设置各个属性的代理， 回调textFieldShouldReturn
    self.coordinate.delegate = self;
    self.personID.delegate = self;
    self.detailAddr.delegate = self;
    self.telephone.delegate = self;
    self.remarks.delegate = self;
    self.email.delegate = self;
    self.parkingNum.delegate = self;
    
    //设置不可编辑， 也可从storyboard设置;
    self.coordinate.enabled = NO;
    self.personID.enabled = NO;

    //当输入框没有内容，水印提示, 可在storyboard设置
//    self.coordinate.placeholder = @"经纬度";
//    self.detailAddr.placeholder = @"详细地址";
//    self.personID.placeholder = @"用户名";
//    self.telephone.placeholder = @"电话号码";
//    self.email.placeholder = @"邮箱地址";
//    self.remarks.placeholder = @"备注";
//    self.parkingNum.placeholder = @"充电桩数量";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //获取用户登入的账户ID;
    self.personID.text = [bixLocalAccount instance].username;
    //解析上报地址的经纬度
    [self parseTest];
    
    //    NSLog(@"chargerInfoViewController");
    //通过通知的手段来解决， 不过比较复杂，换
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseTest:) name:SEND_COORDINATE object:nil];
    //发布通知， 告诉reportMapViewController类 chargerInfoViewController类 注册通知了。
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"chargerInfoViewController" object:self];
}


//-(void)parseTest:(NSNotification*)notification
-(void)parseTest
{
    //    NSLog(@"test is %@", notification.object);
    
    NSLog(@"进入详情页面");
    //    NSString * latitude = [[notification userInfo] valueForKey:@"latitude"];
    //      NSString * longitude = [[notification userInfo] valueForKey:@"longitude"];
    //    NSLog(@"上报详情信息页面  纬度是:%@, 经度是%@", latitude, longitude);
    
    NSMutableString *t1 = [NSMutableString stringWithCapacity:50];
    [t1 appendString:@"纬度:"];
    if (_latitude != NULL) {
        [t1 appendString:_latitude];
    }
    
    [t1 appendString:@"   经度:"];
    if (_longitude != NULL) {
        [t1 appendString:_longitude];
    }
    self.coordinate.text = t1;

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

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
//点击上报按钮触发的事件;

- (IBAction)reportDetailChargerInfo:(id)sender {
//    NSLog(@"点击上报按钮");

    if ([self.telephone.text isEqualToString:@""]) {
        [MessageBox Toast:@"电话号码不能为空" In: self.view];
        NSLog(@"电话号码为空");
        return ;
    }
    if ([self.coordinate.text isEqualToString:@"纬度:   经度:"]) {
        [MessageBox Toast:@"经纬度不能为空，点击上报位置" In: self.view];
        NSLog(@"经纬度为空");
        return ;
    }
    if ([self.detailAddr.text isEqualToString:@""]) {
        [MessageBox Toast:@"充电桩详细地址不能为空" In: self.view];
        return ;
    }
    
    self.mutableArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    [self.mutableArray addObject:self.personID.text];
    NSLog(@"personID is %@", self.personID.text);
    
    [self.mutableArray addObject:self.longitude];
    NSLog(@"longitude is %@", self.longitude);
    
    [self.mutableArray addObject:self.latitude];
    NSLog(@"latitude is %@", self.latitude);
    
//    request = [[RequestInfoFromServer alloc]init];
//    [request sendAsynchronousPostReportChargerRequest:self.mutableArray];
    
}

- (IBAction)backReportMapView:(id)sender {
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
