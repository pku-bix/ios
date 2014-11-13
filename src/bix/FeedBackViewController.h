//
//  FeedBackViewController.h
//  bix
//
//  Created by dsx on 14-10-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *feedBackTextView;

@property (strong, nonatomic) IBOutlet UIButton *btnFeedBack;

- (IBAction)feedBackAction:(id)sender;
- (IBAction)Tap:(id)sender;

@end
 