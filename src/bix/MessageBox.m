//
//  MessageBox.m
//  bix
//
//  Created by harttle on 14-3-7.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MessageBox.h"
#import "MBProgressHUD.h"

@implementation MessageBox

// 提示信息，模态对话框
+ (UIAlertView*) ShowMessage: (NSString*) msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    
    return alert;
}

// 显示提示信息，自动消失
+ (MBProgressHUD*) Toast: (NSString*) msg In: (UIView*)view{
    return [self Toast:msg Mode: MBProgressHUDModeText Within:2.0 In:view];
}

// 显示等待信息，不自动消失
+ (MBProgressHUD*) Toasting: (NSString*) msg In: (UIView*)view{
    return [self  Toast:msg Mode: MBProgressHUDModeIndeterminate In: view];
}

+ (MBProgressHUD*) Toast:(NSString *)msg Mode: (MBProgressHUDMode) mode In: (UIView*)view{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = mode;
    hud.labelText = msg;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (MBProgressHUD*) Toast:(NSString *)msg Within:(NSTimeInterval)time In: (UIView*)view{
    MBProgressHUD* hud = [self Toast:msg In: (UIView*)view];
    [hud hide:YES afterDelay:time];
    return hud;
}

+ (MBProgressHUD*) Toast:(NSString *)msg Mode: (MBProgressHUDMode) mode Within:(NSTimeInterval)time In: (UIView*)view{
    MBProgressHUD* hud = [self Toast:msg Mode:mode In: (UIView*)view];
    [hud hide:YES afterDelay:time];
    return hud;
}

+ (void) clearToasts:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
}

+ (void) hideTopToast:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:NO];
}

@end
