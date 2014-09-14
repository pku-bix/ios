//
//  ChatNavigationController.m
//  bix
//
//  Created by harttle on 14-9-14.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "ChatNavigationController.h"
#import "ChatListViewController.h"

@interface ChatNavigationController ()

@end

@implementation ChatNavigationController

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


// open session without changing push stack, now obsolete
-(void)openSession: (Session*)session{
    ChatListViewController* chatlist = (ChatListViewController*)self.topViewController;
    [chatlist openSession:session];
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

@end
