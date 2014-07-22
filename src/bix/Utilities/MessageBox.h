//
//  MessageBox.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MessageBox : NSObject

+ (UIAlertView*) ShowMessage: (NSString*) msg;
+ (MBProgressHUD*) ShowToast: (NSString*) msg;
+ (MBProgressHUD*) Show: (MBProgressHUDMode) mode Toast:(NSString *)msg;
+ (MBProgressHUD*) ShowToast:(NSString *)msg Within:(NSTimeInterval)time;
+ (MBProgressHUD*) Show: (MBProgressHUDMode) mode Toast:(NSString *)msg Within:(NSTimeInterval)time;

@end