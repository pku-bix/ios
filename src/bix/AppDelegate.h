//
//  AppDelegate.h
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "Account.h"
#import "bixLocalAccount.h"
#import "bixChatProvider.h"
#import "BMapKit.h"
#import "bixMomentDataSource.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>{
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)BMKMapManager* mapManager;

+ (AppDelegate*) instance;
-(void)registerAPN;

@end
