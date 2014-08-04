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
#import "XMPP.h"
#import "XMPPStream+Wrapper.h"
#import "NSString+Account.h"
#import "Constants.h"
#import "UIButton+Bootstrap.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

- (IBAction)Login:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end



@implementation LoginViewController

MBProgressHUD* hud;
Account* account;

// Global App Class
AppDelegate* appdelegate;

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
    
    // retain xmppStream
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // 尝试加载用户
    account = [Account loadDefault];
    if (account != nil) {
        self.username.text = [account.Jid user];
        self.password.text = account.password;
        if(account.autoLogin)   [self doLogin];
    }
    else    [self.username becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(id)sender
{
    // already loaded, update pswd
    if([account.bareJid isEqualToString: [self.username.text toJid]]){
        account.password = self.password.text;
    }
    // new login user
    else{
        account = [Account loadAccount:[self.username.text toJid]];
        
        if(account == nil){
            account = [[Account alloc] initWithUsername:self.username.text
                       Password:self.password.text];
        }
        else    account.password = self.password.text;
    }
    [self doLogin];
}

// 结束输入。
// 对于用户名：关闭软键盘；对于密码：执行登录。
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (textField==self.username) {
        [self.password becomeFirstResponder];
    }
    else if(textField == self.password){
        [self Login: textField];
    }
    return YES;
}


- (void) doLogin{
    hud = [MessageBox Toasting:@"正在连接服务器" In:self.view];
    self.view.userInteractionEnabled = NO;
    
    [appdelegate setupAccount: account];
    [appdelegate.xmppStream reconnect:1];
}

- (void)viewWillAppear:(BOOL)animated{
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
    
    // 上线。登录时完成上线，隐藏tcp重连的细节。
    [appdelegate.xmppStream goOnline];
    
    account.autoLogin = YES;
    [[NSUserDefaults standardUserDefaults] setObject:account.bareJid forKey:KEY_ACTIVE_JID];
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

@end
