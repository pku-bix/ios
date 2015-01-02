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
{
//    CLLocationManager  *locationManager;
}



-(void)registerAPN{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8){
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

-(id)init{
    self = [super init];
    if(self){
        // initialization
    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor blackColor]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // new a thread to make launch interface remain for 1 seconds
    [NSThread sleepForTimeInterval:1];   

    // 要使用百度地图，请先启动BaiduMapManager
    self.mapManager = [[BMKMapManager alloc]init];
    
//    //
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
//        //由于IOS8中定位的授权机制改变 需要进行手动授权
//        locationManager = [[CLLocationManager alloc] init];
//        //获取授权认证
////        [locationManager requestAlwaysAuthorization];
////        NSLog(@"requestAlwaysAuthorization is %@", [locationManager requestAlwaysAuthorization]);
//        [locationManager requestWhenInUseAuthorization];
//    }

    
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
    
    [bixLocalAccount save];
    [bixChatProvider save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [bixChatProvider reconnect];
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


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
#ifdef DEBUG
    NSLog(@"device token received: %@", deviceToken);
#endif
    bixLocalAccount* ac = [bixLocalAccount instance];
    if(ac!=nil){
        NSString* str = deviceToken.description;
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
        ac.deviceToken = str;
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
#ifdef DEBUG
    NSLog(@"failed get device token: %@", error);
#endif
}

+ (AppDelegate*)instance{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end
