//
//  LoginViewController.m
//  bix
//
//  Created by harttle on 14-3-5.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MessageBox.h"
#import "NSString+Account.h"
#import "Constants.h"
#import "UIButton+Bootstrap.h"
#import "MBProgressHUD.h"
#import "bixLocalAccount.h"

@interface LoginViewController ()


@end


@implementation LoginViewController{
    MBProgressHUD* hud;
}

bixLocalAccount* account;

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
	// UI enhancement
    [self.btnLogin primaryStyle];

    // 获取上次登录的用户
    account = [bixLocalAccount restore];
    
    if (account!=nil) {
        self.username.text = account.username;
        self.password.text = account.password;
        if (account.autoLogin) [self doLogin];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    //设置navigationBar隐藏，背景图片顶部才能显示出来。
    [self.navigationController.navigationBar setHidden:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(connected:)
                                                 name:EVENT_CONNECTED   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(connect_timeout:)
                                                 name:EVENT_CONNECT_TIMEOUT   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(connect_error:)
                                                 name:EVENT_DISCONNECTED   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(authenticated:)
                                                 name:EVENT_AUTHENTICATED   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(authenticate_failed:)
                                                 name:EVENT_AUTHENTICATE_FAILED   object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    if (self.username && ![self.username.text isEqualToString:@""]) {
        //[self textFieldDidEndEditing:self.username];
        [self.password becomeFirstResponder];
    }
    else{
        [self.username becomeFirstResponder];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_CONNECTED  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_CONNECT_TIMEOUT  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_DISCONNECTED  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_AUTHENTICATED  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_AUTHENTICATE_FAILED  object:nil];
}

-(void) doLogin{
    hud = [MessageBox Toasting:@"正在连接服务器" In:self.view];
    self.view.userInteractionEnabled = NO;
    
    [bixChatProvider setLocalAccount:account];
    [[bixChatProvider defaultChatProvider] keepConnectedAndAuthenticated:3];
}

- (IBAction)Login:(id)sender
{
    // validate
    if (!self.username.text.isValidUsername || !self.password.text.isValidPassword) {
        [MessageBox Toast:@"用户名或密码格式错误" In:self.view];
        self.view.userInteractionEnabled = YES;
        return;
    }
    
    // account not valid
    if (account == nil || ![account.username isEqualToString:self.username.text]) {
        account = [bixLocalAccount loadOrCreate: self.username.text Password: self.password.text];
    }
    // account valid
    else{
        account.password = self.password.text;
    }
    
    [self doLogin];
}

- (void)connected:(NSNotification*)n{
    hud.labelText = @"正在验证";
}
- (void)connect_error:(NSNotification*)n{
    [hud hide:YES];
    [MessageBox Toast:@"连接服务器错误，请检查网络设置" In:self.view];
    self.view.userInteractionEnabled = YES;
}
- (void)connect_timeout:(NSNotification*)n{
    [hud hide:YES];
    [MessageBox Toast:@"连接服务器超时，请检查网络设置" In:self.view];
    self.view.userInteractionEnabled = YES;
}
- (void)authenticated:(NSNotification*)n{
    [hud hide:YES];
    self.view.userInteractionEnabled = YES;
    
    [[AppDelegate instance] registerAPN];
    
    [self performSegueWithIdentifier:@"main" sender:self];
}
- (void)authenticate_failed:(NSNotification*)n{
    [hud hide:YES];
    [MessageBox Toast:@"用户名或密码不正确" In: self.view];
    
    self.password.text = @"";
    account.autoLogin = NO;
    account.password = @"";
    [account save];
    self.view.userInteractionEnabled = YES;
}

// keyboard dismiss
- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication]
     sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

// username end editing
- (void) textFieldDidEndEditing:(UITextField *)textField{
    if (textField==self.username) {

        if (self.username.text.isValidUsername) {
            account = [bixLocalAccount loadByUsername:self.username.text];
            if (account) {  // loaded
                self.password.text = account.password;      // fill passwd
                if(account.autoLogin)   [self Login:self];
            }
            else{           // can't load
                self.password.text = @"";
                [self.password becomeFirstResponder];
            }
        }
    }
}

// textfiled return
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if(textField == self.password){
        [self Login: self];
    }
    else if (textField == self.username){
        [self.password becomeFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerNewUsername:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}
@end
