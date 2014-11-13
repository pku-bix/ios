//
//  teslaTypeViewController.m
//  bix
//
//  Created by dsx on 14-10-20.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "teslaTypeViewController.h"
#import "AppDelegate.h"

@interface teslaTypeViewController ()

@end

@implementation teslaTypeViewController

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
    self.teslaType.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)saveTeslaType:(id)sender {
    NSLog(@"teslaType is %@", self.teslaType.text);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TeslaType" object:self.teslaType.text];
    
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    account.setTeslaType = self.teslaType.text;
    [account save];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
