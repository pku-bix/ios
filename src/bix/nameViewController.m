//
//  nameViewController.m
//  bix
//
//  Created by dsx on 14-10-19.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "nameViewController.h"
#import "AppDelegate.h"
#import "RequestInfoFromServer.h"
#import "Constants.h"

@interface nameViewController ()

@end

@implementation nameViewController
{
    AppDelegate * appDelegate;
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
    //    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    appDelegate.account.setName
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

- (IBAction)saveAndReturn:(id)sender {
    //     self.nameTextField
    NSLog(@"%@", self.nameTextField.text);
    Account* account = [(AppDelegate *)[UIApplication sharedApplication].delegate account];
    //上传修改的名字字段;
    request = [[RequestInfoFromServer alloc]init];
    [request sendAsynchronousPostTextRequest:self.nameTextField.text type:NAME_TYPE];
    
    //将设置的名字字段保存在account.setName中;
    //    appDelegate.account.setName = self.nameTextField.text;
    account.setName = self.nameTextField.text;
    [account save];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"nameChange" object:self.nameTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
