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
#import "Chatter.h"
#import "BMapKit.h"
#import "bixMomentDataSource.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>{
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)BMKMapManager* mapManager;
@property (nonatomic)Chatter* chatter;
@property (nonatomic)bixLocalAccount* account;
@property bixMomentDataSource* momentDataSrouce;

+ (AppDelegate*) get;

@end
