
//
//  MainTabBarController.m
//  bix
//
//  Created by harttle on 14-3-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MainTabBarController.h"
#import "AppDelegate.h"
#import "ChatListViewController.h"
#import "Constants.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

AppDelegate *appdelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self performSegueWithIdentifier:@"login" sender:self];
    }
    return self;
}

// open session without changing push stack,
// now obsolete
-(void)openSession: (Session*)session{
    //[self setSelectedIndex:1];
    
    UINavigationController* nav = (UINavigationController*)self.selectedViewController;

    ChatListViewController* chatlist = (ChatListViewController*)nav.topViewController;
    [chatlist openSession:session];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(messageDidReceive)
                                                 name:EVENT_MESSAGE_RECEIVED object:nil];
}

- (void)messageDidReceive{
    if (self.selectedIndex != 1) {
        UITabBarItem* item = self.tabBar.items[1];
        item.badgeValue = [@([bixChatProvider defaultChatProvider].unReadMsgCount) stringValue];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
