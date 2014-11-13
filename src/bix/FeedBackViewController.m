//
//  FeedBackViewController.m
//  bix
//
//  Created by dsx on 14-10-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UIButton+Bootstrap.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

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
    [self.btnFeedBack primaryStyle];
    
    self.feedBackTextView.delegate = self;
    //    [self.navigationController.navigationBar setHidden:YES];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor whiteColor];
    
}

//-(BOOL)text

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
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

- (IBAction)feedBackAction:(id)sender {
}

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
