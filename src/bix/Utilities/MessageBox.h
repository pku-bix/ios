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
+ (MBProgressHUD*) Toast: (NSString*) msg In: (UIView*)view;
+ (MBProgressHUD*) Toasting: (NSString*) msg In: (UIView*)view;
+ (MBProgressHUD*) Toast:(NSString *)msg Mode: (MBProgressHUDMode) mode In: (UIView*)view;
+ (MBProgressHUD*) Toast:(NSString *)msg Mode: (MBProgressHUDMode) mode Within:(NSTimeInterval)time In: (UIView*)view;
+ (void) hideTopToast:(UIView *)view;
+ (void) clearToasts:(UIView *)view;

@end