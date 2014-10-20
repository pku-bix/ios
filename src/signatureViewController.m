//
//  signatureViewController.m
//  bix
//
//  Created by dsx on 14-10-20.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "signatureViewController.h"
#import "AppDelegate.h"

@interface signatureViewController ()

@end

@implementation signatureViewController

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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
