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
{
//    int pictureNumber ;

}

@property(nonatomic)int pictureNumber; //添加的图片数量;

@property(nonatomic) NSMutableArray *mutableArray;

@property(strong,nonatomic) NSObject<PassImageDelegate> *delegate;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property(nonatomic,strong) UIImage *image1;
@property(nonatomic,strong) UIImage *image2;
@property(nonatomic,strong) UIImage *image3;
@property(nonatomic,strong) UIImage *image4;
@property(nonatomic,strong) UIImage *image5;
@property(nonatomic,strong) UIImage *image6;
@property(nonatomic,strong) UIImage *image7;
@property(nonatomic,strong) UIImage *image8;
@property(nonatomic,strong) UIImage *image9;

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;
@property (strong, nonatomic) IBOutlet UIImageView *imageView5;
@property (strong, nonatomic) IBOutlet UIImageView *imageView6;
@property (strong, nonatomic) IBOutlet UIImageView *imageView7;
@property (strong, nonatomic) IBOutlet UIImageView *imageView8;
@property (strong, nonatomic) IBOutlet UIImageView *imageView9;


- (IBAction)cancleSendMood:(id)sender;

- (IBAction)addPicture:(id)sender;

- (IBAction)sendTextAndPicture:(id)sender;

- (IBAction)Tap:(id)sender;

@end
