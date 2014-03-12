//
//  MessageBox.m
//  bix
//
//  Created by harttle on 14-3-7.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MessageBox.h"

@implementation MessageBox

+ (void) ShowMessage: (NSString*) msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}
@end
