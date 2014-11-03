//
//  signatureViewController.h
//  bix
//
//  Created by dsx on 14-10-20.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signatureViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *signature;

- (IBAction)saveSignature:(id)sender;
@end
