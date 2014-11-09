//
//  bixSendMoodData.h
//  bix
//
//  Created by dsx on 14-11-4.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassImageDelegate.h"

@interface bixSendMoodData : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassImageDelegate>

@property(strong,nonatomic) NSObject<PassImageDelegate> *delegate;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) UIImage *image3;

- (IBAction)cancleSendMood:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *image1;
- (IBAction)addPicture:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
- (IBAction)Tap:(id)sender;

@end
