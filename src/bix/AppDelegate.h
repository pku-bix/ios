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
#import "DataWorker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Account *_account;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain)DataWorker* dataWorker;
@property (nonatomic, retain)XMPPStream* xmppStream;
@property (nonatomic, retain)Account* account;


// account should be set before call this method
-(void)setupStream;

@end
