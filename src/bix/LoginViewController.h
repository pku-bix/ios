//
//  LoginViewController.h
//  bix
//
//  Created by harttle on 14-3-5.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) Account* account;

@end
