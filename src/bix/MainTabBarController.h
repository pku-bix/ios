//
//  MainTabBarController.h
//  bix
//
//  Created by harttle on 14-3-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface MainTabBarController : UITabBarController

-(void)openSession: (Session*)session;

@end
