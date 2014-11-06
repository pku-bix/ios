//
//  bixSendMoodData.h
//  bix
//
//  Created by dsx on 14-11-4.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassImageDelegate.h"

@interface bixSendMoodData : UIViewController<PassImageDelegate>

@property(strong,nonatomic) NSObject<PassImageDelegate> *delegate;
@property(nonatomic,strong) UIImage *image;

- (IBAction)cancleSendMood:(id)sender;

- (IBAction)sendMood:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *image1;

@end
