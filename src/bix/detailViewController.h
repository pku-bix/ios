//
//  detailViewController.h
//  bix
//
//  Created by dsx on 14-10-1.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController

@property NSString* szAddress;
@property (strong, nonatomic) IBOutlet UILabel *address;

//- (IBAction)back:(id)sender;
- (IBAction)back:(id)sender;

@end
