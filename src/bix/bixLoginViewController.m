//
//  bixLoginViewController.m
//  bix
//
//  Created by harttle on 14-3-5.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixLoginViewController.h"

@interface bixLoginViewController ()
- (IBAction)Login:(id)sender;
- (IBAction)Register:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation bixLoginViewController

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

- (IBAction)Login:(id)sender {
    NSLog(@"%@ %@",self.username.text,self.password.text);
}

- (IBAction)Register:(id)sender {
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];    return YES;
}
@end
