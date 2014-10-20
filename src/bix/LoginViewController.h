//
//  LoginViewController.h
//  bix
//
//  Created by harttle on 14-3-5.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)registerNewUsername:(id)sender;



@end
