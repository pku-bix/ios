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
#import "XMPPStream+Wrapper.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()
- (IBAction)register:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pswd;
@property (weak, nonatomic) IBOutlet UITextField *pswd2;

@end

@implementation RegisterViewController

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
    
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self.username becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)register:(id)sender {
    if(![self.username.text isValidUsername]){
        [MessageBox ShowMessage:@"用户名只能由字母与数字组成，以字母开头，并且不超过32个字符。"];
        return;
    }
    
    if(![self.pswd.text isEqualToString:self.pswd2.text]){
        
        [MessageBox ShowToast:@"两次输入的密码不一致，请确认。"];
        return;
    }
    
    //do register
    Account* account = [[Account alloc]
                        initWithUsername:self.username.text
                        Password:self.pswd.text];
    
    [appdelegate setupAccount: account];
    [appdelegate.xmppStream addDelegate: self delegateQueue:dispatch_get_main_queue()];
    
    // do wait
    self.view.userInteractionEnabled = NO;
    [MessageBox Show:MBProgressHUDModeIndeterminate Toast:@"正在连接服务器" ];
    
    [appdelegate.xmppStream connect];
    
}

// connect succeed
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    if(![appdelegate.xmppStream registerAccount]){
        
        self.view.userInteractionEnabled = YES;
        [MessageBox ShowToast:@"未知错误，请联系管理员。"];
    }
    
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
    self.view.userInteractionEnabled = YES;
    [MessageBox ShowToast: @"连接服务器错误，请检查网络设置"];
}
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    
    self.view.userInteractionEnabled = YES;
    [MessageBox ShowToast: @"连接服务器超时，请检查网络设置"];
}


// register succeed
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    self.view.userInteractionEnabled = YES;
    
    [MessageBox ShowToast:@"注册成功！"];
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
    self.view.userInteractionEnabled = YES;
    [MessageBox ShowToast:@"注册失败，请联系管理员。"];
    NSLog(@"register error: %@", error);
}

@end
