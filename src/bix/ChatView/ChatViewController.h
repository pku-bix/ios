//
//  ChatViewController.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface ChatViewController : UITableViewController

@property (nonatomic,retain) Session* session;

@end
