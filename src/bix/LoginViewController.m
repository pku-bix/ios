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

@interface LoginViewController ()

- (IBAction)Login:(id)sender;

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
    
    // get active user
    if (!self.username.text || [self.username.text isEqualToString:@""]) {
        NSString *tmp = [Account getActiveJid];
        self.username.text = tmp==nil ? @"" : [tmp toUsername];
    }
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
-(void)viewDidAppear:(BOOL)animated{
    if (self.username && ![self.username.text isEqualToString:@""]) {
        [self textFieldDidEndEditing:self.username];
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

- (IBAction)Login:(id)sender
{
    // loaded
    if(account && [account.bareJid isEqualToString: [self.username.text toJid]]){
        account.password = self.password.text;
    }
    // not loaded
    else{
        account = [[Account alloc] initWithUsername:self.username.text
                                               Password:self.password.text];
    }
    // do login
    hud = [MessageBox Toasting:@"正在连接服务器" In:self.view];
    self.view.userInteractionEnabled = NO;
    
    appdelegate.account = account;
    [appdelegate.chatter keepConnectedAndAuthenticated:1];
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
        // valid username
        if (self.username.text && ![self.username.text isEqualToString:@""]) {
            
            account = [Account loadAccount:[self.username.text toJid] ];
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

// passwd return
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if(textField == self.password){
        [self Login: self];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
