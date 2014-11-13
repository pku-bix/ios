//
//  nameViewController.h
//  bix
//
//  Created by dsx on 14-10-19.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nameViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)saveAndReturn:(id)sender;

@end
