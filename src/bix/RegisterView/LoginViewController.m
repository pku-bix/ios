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
	// Do any additional setup after loading the view.
    
    // UI enhancement
    [self.btnLogin primaryStyle];
    
    
    // retain xmppStream
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // add self to xmppStream delegate
    [appdelegate.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // auto login
    account = [Account loadDefault];
    if (account != nil) {
        
        self.username.text = [account.Jid user];
        self.password.text = account.password;
        
        if(account.autoLogin){
            [self doLogin];
        }
    }
    else{
        [self.username becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(id)sender
{
    // already loaded
    if([account.bareJid isEqualToString: [self.username.text toJid]]){
        
        // update pswd
        account.password = self.password.text;
    }
    // new login user
    else{
        
        // try load account
        account = [Account loadAccount:[self.username.text toJid]];
        
        if(account == nil){
            
            // create account
            account = [[Account alloc]
                       initWithUsername:self.username.text
                       Password:self.password.text];
        }
        else{
            account.password = self.password.text;
        }
    }
    
    // try to login
    [self doLogin];
}


// close input
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



//////////////////////////////////////////////////////////////////////////////////////////
// private methods

- (void) doLogin{
    
    self.view.userInteractionEnabled = NO;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在连接服务器";
    
    [appdelegate setupAccount: account];
    [appdelegate.xmppStream addDelegate: self delegateQueue:dispatch_get_main_queue()];
    
    [appdelegate.xmppStream connect];
}


// connect succeed
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    hud.labelText = @"正在验证";
    [appdelegate.xmppStream authenticate];
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"连接服务器错误，请检查网络设置";
    [hud hide:YES afterDelay:2.0];
    
    self.view.userInteractionEnabled = YES;
}
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"连接服务器超时，请检查网络设置";
    [hud hide:YES afterDelay:2.0];
    
    self.view.userInteractionEnabled = YES;
}


// authentication
- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    [appdelegate.xmppStream goOnline];
    account.autoLogin = YES;
    [[NSUserDefaults standardUserDefaults] setObject:account.bareJid forKey:KEY_ACTIVE_JID];
    
    self.view.userInteractionEnabled = YES;
    
    [self performSegueWithIdentifier:@"main" sender:self];
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"用户名或密码不正确";
    [hud hide:YES afterDelay:2.0];
    
    self.view.userInteractionEnabled = YES;
}


// keyboard dismiss
- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
