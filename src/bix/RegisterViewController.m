//
//  RegisterViewController.m
//  bix
//
//  Created by harttle on 14-4-30.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+Account.h"
#import "MessageBox.h"
#import "Account.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "LoginViewController.h"

@interface RegisterViewController ()
- (IBAction)register:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pswd;
@property (weak, nonatomic) IBOutlet UITextField *pswd2;

@end

@implementation RegisterViewController

// Global App Class
AppDelegate* appdelegate;
MBProgressHUD* hud;
bool succeed;   // indicate whether register succeed

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
    [self.username becomeFirstResponder];
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(connected:)
                                                 name:EVENT_CONNECTED   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(connect_timeout:)
                                                 name:EVENT_CONNECT_TIMEOUT   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(connect_error:)
                                                 name:EVENT_DISCONNECTED   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(registered:)
                                                 name:EVENT_REGISTERED   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(register_failed:)
                                                 name:EVENT_REGISTER_FAILED   object:nil];
    succeed = false;
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_CONNECTED  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_CONNECT_TIMEOUT  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_DISCONNECTED  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_REGISTERED  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_REGISTER_FAILED  object:nil];
}

- (IBAction)register:(id)sender {
    if(![self.username.text isValidUsername]){
        [MessageBox ShowMessage:@"用户名只能由字母与数字组成，以字母开头，并且不超过32个字符。"];
        return;
    }
    
    if(![self.pswd.text isEqualToString:self.pswd2.text]){
        [MessageBox Toast:@"两次输入的密码不一致，请确认。" In: self.view];
        return;
    }
    
    // setup account
    bixLocalAccount* account = [[bixLocalAccount alloc]
                        initWithUsername:self.username.text
                        Password:self.pswd.text];
    appdelegate.account = account;
    
    // do wait
    self.view.userInteractionEnabled = NO;
    hud = [MessageBox Toast:@"正在连接服务器" Mode:MBProgressHUDModeIndeterminate In: self.view];
    [appdelegate.chatter keepConnected:1];
}

// connect succeed
- (void)connected:(NSNotification*)n{
    [MessageBox hideTopToast:self.view];
    
    if(![appdelegate.chatter registerAccount]){
        self.view.userInteractionEnabled = YES;
        [hud hide:YES];
        [MessageBox Toast:@"未知错误，请联系管理员。" In: self.view];
    }
    else{
        hud.labelText = @"正在注册";
    }
}
// connect error
- (void)connect_error:(NSNotification*)n{
    self.view.userInteractionEnabled = YES;
    [hud hide:YES];
    [MessageBox Toast: @"连接服务器错误，请检查网络设置" In: self.view];
}
// connect timeout
- (void)connect_timeout:(NSNotification*)n{
    self.view.userInteractionEnabled = YES;
    [hud hide:YES];
    [MessageBox Toast: @"连接服务器超时，请检查网络设置" In: self.view];
}
// register succeed
- (void)registered:(NSNotification*)n{
    self.view.userInteractionEnabled = YES;
    [hud hide:YES];
    [MessageBox ShowMessage:@"注册成功！"];
    succeed = true;
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[LoginViewController class]] && succeed) {
        
        LoginViewController *v = (LoginViewController*) viewController;
        v.username.text = self.username.text;
    }
}
// register failed
- (void)register_failed:(NSNotification*)n{
    self.view.userInteractionEnabled = YES;
    [hud hide:YES];
    
    NSString *info=@"未知错误，请联系管理员。";
    NSXMLElement *error = [[[n userInfo] objectForKey:@"error"] elementForName:@"error"];
    if(error){
        if([error elementForName:@"conflict"])
            info = @"用户名已存在，请使用新的用户名";
    }
    [MessageBox ShowMessage:info];
}

@end
