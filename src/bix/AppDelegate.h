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

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Account *_account;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain)XMPPDelegate* xmppDelegate;
@property (nonatomic, retain)XMPPStream* xmppStream;
@property (nonatomic, retain)Account* account;

// account should be set before call this method
-(void)setupStream;

@end
