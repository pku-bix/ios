//
//  AddContactViewController.m
//  bix
//
//  Created by harttle on 14-3-19.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "AddContactViewController.h"
#import "NSString+Account.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "MessageBox.h"

@interface AddContactViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;

- (IBAction)Add:(id)sender;
- (IBAction)Tap:(id)sender;

@end

@implementation AddContactViewController
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
}

- (void)viewWillAppear:(BOOL)animated{
    [self.username becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Add:(id)sender {
    // valid check
    if (!self.username.text.isValidUsername)
        return;
    
    Account* account = [bixLocalAccount instance];
    
    NSString* username = [self.username.text
                      stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if( [account.username isEqualToString: username] ){
        [MessageBox ShowMessage:@"不可添加当前用户"];
        return;
    }
    [[bixChatProvider defaultChatProvider] getConcactByUsername:username];
    [account save];

    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [self Add:textField];
    return NO;
}

@end
