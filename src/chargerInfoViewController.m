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

@interface chargerInfoViewController ()

@end

@implementation chargerInfoViewController
{
    AppDelegate * appDelegate;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //获取用户登入的账户ID;
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.personID.text = appDelegate.account.username;
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

@end
