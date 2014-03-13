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



@interface LoginViewController ()

- (IBAction)Login:(id)sender;
- (IBAction)Register:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end



@implementation LoginViewController

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
    self.account = [Account loadDefault];
    if (self.account != nil) {
        
        self.username.text = self.account.username;
        self.password.text = self.account.password;
        
        if(self.account.autoLogin){
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
    [self generateAccount];
    
    if ([self.account isValid]){
        [self doLogin];
    }
    else{
        [MessageBox ShowMessage: @"账户格式不正确"];
    }
}


- (IBAction)Register:(id)sender {
    [MessageBox ShowMessage: @"正在内测期间，很快会开放注册!"];
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


- (void) generateAccount{
    self.account = [[Account alloc] initWithUsername: self.username.text
                                       Password:self.password.text];
}

- (void) doLogin{
    self.btnLogin.enabled = false;
    
    appdelegate.account = self.account;
    [appdelegate setupStream];
    [appdelegate.xmppStream addDelegate: self delegateQueue:dispatch_get_main_queue()];
    
    if([appdelegate.xmppStream connect]) {
        
        //save now!
        [self.account save];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        self.btnLogin.enabled = true;
        
        [MessageBox ShowMessage: @"无法连接到服务器，请检查网络设置"];
    }
}

// connect succeed
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    [appdelegate.xmppStream authenticate];
}


// authentication succeed
- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    // update info
    self.account.autoLogin = YES;
    
    // go online
    [appdelegate.xmppStream goOnline];
    [appdelegate.dataWorker.contacts addObject:self.account];
    
    // navigation
    [self performSegueWithIdentifier:@"main" sender:self];
}


//authentication failed
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    
    self.btnLogin.enabled = true;
    [MessageBox ShowMessage: @"用户名或密码不正确"];
}

@end
