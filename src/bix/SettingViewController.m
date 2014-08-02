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

@interface SettingViewController ()
- (IBAction)Logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@end

@implementation SettingViewController
{
    CGRect rect;
    UITextView *_textView;
    UITextView *_textViewTitle;
    NSString *aboutApp;
    
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
    rect = [[UIScreen mainScreen] bounds];
    UIImage *image = [UIImage imageNamed:@"Tesla.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake((rect.size.width-image.size.width)/2, 90, image.size.width, image.size.height);
   // imageView.backgroundColor = [UIColor greenColor];
    //imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    _textViewTitle = [[UITextView alloc] init];
    _textViewTitle.frame = CGRectMake((rect.size.width-image.size.width)/2-10, 90+image.size.height+20, image.size.width+30, 50);
    _textViewTitle.text = @"       关于Bix";
    _textViewTitle.font = [UIFont boldSystemFontOfSize:16];
    
    _textViewTitle.editable = NO;
    [self.view addSubview:_textViewTitle];
    
    _textView = [[UITextView alloc]init];
    _textView.frame = CGRectMake((rect.size.width-image.size.width)/2-25, 90+image.size.height+20+30, image.size.width+60, 150);
    aboutApp = @"本软件是一款集地图、社交、共享于一体的app，旨在通过地图和社交元素帮助电动汽车共享充电桩、共享汽车，从而方便用户，建立圈子.";
    _textView.text = aboutApp;
    _textView.font = [UIFont systemFontOfSize:15];
   //_textView.text = [_textView.text stringByAppendingString:aboutApp];
    
    _textView.editable = NO;
    [self.view addSubview: _textView];
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

@end
