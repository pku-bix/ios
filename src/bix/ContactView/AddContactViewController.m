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

@interface AddContactViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;

- (IBAction)Add:(id)sender;
- (IBAction)Tap:(id)sender;

@end

@implementation AddContactViewController

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
    
    Account* account = [(AppDelegate *)[UIApplication sharedApplication].delegate account];
    
    NSString* user = [self.username.text
                      stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* bareJid = [user stringByAppendingFormat:@"@%@",SERVER_DOMAIN];
    [account updateConcact:[XMPPJID jidWithString:bareJid]];
    [account save];
    
    //NSLog(@"%d",account.contacts.count);

    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
//    if (textField==self.username) {
//        
//    }
    return NO;
}

@end
