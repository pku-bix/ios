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
#import "MainTabBarController.h"

@implementation AppDelegate

///////////////////////////////////////////////////////////////
//properties

@synthesize account;


//MainTabBarController* mainTabBarController;



////////////////////////////////////////////////////////////////
//methods


-(id)init{
    self = [super init];
    if(self){
        // initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLogOut:)
                                                     name:EVENT_DISCONNECTED
                                                   object:nil];
    }
    return self;
}


-(void)setupAccount: (Account*) ac{
    
    self.account = ac;
    
    self.xmppDelegate.account = ac;
    
    //释放原来的代理
    [self.xmppStream removeDelegate:self.xmppDelegate];

    //初始化XMPPStream
    self.xmppStream = [[XMPPStream alloc] initWithAccount:self.account];
    [self.xmppStream addDelegate:self.xmppDelegate delegateQueue:dispatch_get_main_queue()];
}

-(void) logOut{
    [self.xmppStream disconnectAfterSending];
}

-(void) didLogOut: (NSNotification*) notification{
    
    //释放代理
    [self.xmppStream removeDelegate:self.xmppDelegate];

    account.autoLogin = false;
    [account save];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [(UINavigationController*)self.window.rootViewController pushViewController:lvc animated:NO];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    // new a thread to make launch interface remain for 1 seconds
    [NSThread sleepForTimeInterval:1];
    

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDU_MAP_KEY  generalDelegate:self];
    
#ifdef DEBUG
    if (!ret) {
        NSLog(@"manager start failed!");
    }
#endif
    //NSLog(@"didFinishLaunchingWithOption");
    
    self.xmppDelegate = [XMPPDelegate new];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_DISCONNECTED
                                                  object:nil];
    if (self.account.presence) {
        [self.account save];
    }
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
    
    // not guaranteed to be called!
    // use applicationDidEnterBackground to save data.
}

@end
