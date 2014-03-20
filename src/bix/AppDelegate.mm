//
//  AppDelegate.m
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "XMPPStream+Wrapper.h"

@implementation AppDelegate

///////////////////////////////////////////////////////////////
//properties


@synthesize account = _account;

- (void) setAccount:(Account *)newAccount{
    _account = newAccount;
    
    //record active account
    [[NSUserDefaults standardUserDefaults] setObject:newAccount.Jid.bare forKey:KEY_ACTIVE_JID];
}




////////////////////////////////////////////////////////////////
//methods


-(id)init{
    self = [super init];
    if(self){
        // initialization
    }
    return self;
}


-(void)setupStream{
    
    //初始化XMPPStream
    self.xmppStream = [[XMPPStream alloc] initWithAccount:self.account];
    [self.xmppStream addDelegate:self.xmppDelegate delegateQueue:dispatch_get_main_queue()];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDU_MAP_KEY  generalDelegate:self];
    
#ifdef DEBUG
    if (!ret) {
        NSLog(@"manager start failed!");
    }
#endif
    
    //  BMKMapView* mapView2 = [[BMKMapView alloc]initWithFrame:CGRectMake(50, 50, 300, 500)];
    
    // Add the navigation controller's view to the window and display.
    //[self.window addSubview:navigationController.view];
    // [_mapManager release];
    //      [_mapManager release];
    //[self.window addSubview:mapView2];
    
    /*[self.window addSubview: self.navigationController.view];
    [self.window makeKeyAndVisible];*/
    
    
    self.xmppDelegate = [XMPPDelegate new];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // save account states
    
    [self.account save];
}

@end
