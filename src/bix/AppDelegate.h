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
#import "Chatter.h"
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>{
    Account *_account;
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)Chatter* chatter;
@property (nonatomic)Account* account;

@end
