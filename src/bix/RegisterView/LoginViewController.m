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


@interface LoginViewController ()

- (IBAction)Login:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end



@implementation LoginViewController

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
    // try to load
    if([account.bareJid isEqualToString: [self.username.text toJid]]){
        
        // already loaded, update pswd
        account.password = self.password.text;
    }
    else{
        account = [Account loadAccount:[self.username.text toJid]];
        if(account == nil){
            account = [[Account alloc]
                    initWithUsername:self.username.text
                    Password:self.password.text];
        }
        else{
            account.password = self.password.text;
        }
    }
    
    // try to login
    if ([account isValid]){
        [self doLogin];
    }
    else{
        [MessageBox ShowMessage: @"账户格式不正确"];
    }
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
    self.btnLogin.enabled = false;
    
    [appdelegate setupAccount: account];
    [appdelegate.xmppStream addDelegate: self delegateQueue:dispatch_get_main_queue()];
    
    if(![appdelegate.xmppStream connect]){
        
        self.btnLogin.enabled = true;
        [MessageBox ShowMessage: @"无法连接到服务器，请检查网络设置"];
    }
    else{
        //mark account as active
        [[NSUserDefaults standardUserDefaults] setObject:account.bareJid forKey:KEY_ACTIVE_JID];
    }
}

// connect succeed
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    [appdelegate.xmppStream authenticate];
}


// authentication succeed
- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    account.autoLogin = YES;

    [appdelegate.xmppStream goOnline];
    
    [self performSegueWithIdentifier:@"main" sender:self];
}


//authentication failed
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    
    self.btnLogin.enabled = true;
    
    [MessageBox ShowMessage: @"用户名或密码不正确"];
}

@end
