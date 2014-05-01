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
#import "XMPPDelegate.h"
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>{
    Account *_account;
    BMKMapManager* _mapManager;
    BMKMapView *_mapView2;

}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain)XMPPDelegate* xmppDelegate;
@property (nonatomic, retain)XMPPStream* xmppStream;
@property (nonatomic, retain)Account* account;

// account should be set before call this method
-(void)setupAccount: (Account*)account;


@end
