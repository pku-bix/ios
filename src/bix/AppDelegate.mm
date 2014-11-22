//
//  AppDelegate.m
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "MainTabBarController.h"
#import "SettingViewController.h"
#import "bixMomentDataItem.h"
#import <UIKit/UIKit.h>

@implementation AppDelegate

///////////////////////////////////////////////////////////////
//properties

-(void)setAccount:(bixLocalAccount *)account{
    _account = account;
    
    self.chatter = [[ChatProvider alloc] initWithAccount: account];
    [self.chatter loadData];
    
    if(!account.deviceToken){
        
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

////////////////////////////////////////////////////////////////
//methods


-(id)init{
    self = [super init];
    if(self){
        // initialization
        _momentDataSrouce = [bixMomentDataSource new];
    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    // new a thread to make launch interface remain for 1 seconds
    [NSThread sleepForTimeInterval:1];   

    // 要使用百度地图，请先启动BaiduMapManager
    self.mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    
//#ifdef DEBUG
   // BOOL ret = [_mapManager start:BAIDU_MAP_KEY  generalDelegate:self];
    
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
//#else
    
    [_mapManager start:BAIDU_MAP_KEY  generalDelegate:self];
    
//#endif
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   // NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (self.account.presence) {
        [self.account save];
        [self.chatter saveData];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (self.account.presence) {
        [self.chatter keepConnected:-1];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // not guaranteed to be called!
    // use applicationDidEnterBackground to save data.
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

#ifdef DEBUG
    NSLog(@"device token received: %@", deviceToken);
#endif
    self.account.deviceToken = deviceToken;
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
#ifdef DEBUG
    NSLog(@"failed get device token: %@", error);
#endif
}

+ (AppDelegate*)get{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end
