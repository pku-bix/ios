//
//  signatureViewController.m
//  bix
//
//  Created by dsx on 14-10-20.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "signatureViewController.h"
#import "AppDelegate.h"
#import "RequestInfoFromServer.h"
#import "Constants.h"

@interface signatureViewController ()

@end

@implementation signatureViewController
{
    RequestInfoFromServer *request;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseTest:) name:@"nameChange" object:nil];
    request = [[RequestInfoFromServer alloc]init];
}


-(void)parseTest:(NSNotification*)notification
{
    NSString *test1 = notification.object;
    NSLog(@"test is %@", test1);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveSignature:(id)sender {
    NSLog(@"signature is %@", self.signature.text);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"signatureChange" object:self.signature.text];
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    account.setSignature = self.signature.text;
    [account save];
    //发送图片、文字的异步信息;
//    [request sendAsynchronousPostRequest];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
