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

+ (UIAlertView*) ShowMessage: (NSString*) msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    
    return alert;
}


+ (MBProgressHUD*) ShowToast: (NSString*) msg{
    return [self Show: MBProgressHUDModeText Toast:msg Within:2.0];
}

+ (MBProgressHUD*) Show: (MBProgressHUDMode) mode Toast:(NSString *)msg{
    
    UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
    UIView *topView = [[topWindow subviews] lastObject];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:topView animated:YES];
    
    hud.mode = mode;
    hud.labelText = msg;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (MBProgressHUD*) ShowToast:(NSString *)msg Within:(NSTimeInterval)time{
    MBProgressHUD* hud = [self ShowToast:msg];
    [hud hide:YES afterDelay:time];
    return hud;
}

+ (MBProgressHUD*) Show: (MBProgressHUDMode) mode Toast:(NSString *)msg Within:(NSTimeInterval)time{
    MBProgressHUD* hud = [self Show: mode Toast:msg];
    [hud hide:YES afterDelay:time];
    return hud;
}

@end
