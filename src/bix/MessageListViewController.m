//
//  MessageListViewController.m
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MessageListViewController.h"

@interface MessageListViewController ()
- (IBAction)testBtn:(id)sender;

@end

@implementation MessageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testBtn:(id)sender {
    [self performSegueWithIdentifier:@"login" sender:self];
}
@end
