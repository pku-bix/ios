//
//  ChatNavigationController.h
//  bix
//
//  Created by harttle on 14-9-14.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface ChatNavigationController : UINavigationController

-(void)openSession: (Session*)session;

@end
