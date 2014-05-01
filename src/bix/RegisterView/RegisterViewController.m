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
    
    if([self.pswd.text isEqualToString:self.pswd2.text]){
        //do register
        Account* account = [[Account alloc]
                        initWithUsername:self.username.text
                        Password:self.pswd.text];
        
        [appdelegate setupAccount: account];
        [appdelegate.xmppStream addDelegate: self delegateQueue:dispatch_get_main_queue()];
        
        if(![appdelegate.xmppStream connect]) {
            [MessageBox ShowMessage: @"无法连接到服务器，请检查网络设置"];
        }
    }
    else{
        [MessageBox ShowMessage:@"两次输入的密码不一致，请确认。"];
        return;
    }
}


// connect succeed
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSString* result = [appdelegate.xmppStream registerAccount];
    
    if(result == nil){
        // success
        [MessageBox ShowMessage:@"注册成功！"];
        [self.navigationController popToRootViewControllerAnimated:true];
    }
    else{
        NSLog(@"register failed:%@", result);
    }
}

@end
