//
//  teslaTypeViewController.h
//  bix
//
//  Created by dsx on 14-10-20.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface teslaTypeViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *teslaType;
- (IBAction)saveTeslaType:(id)sender;
- (IBAction)Tap:(id)sender;

@end
