//
//  bixSendMoodData.h
//  bix
//
//  Created by dsx on 14-11-4.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassImageDelegate.h"
#import "bixRemoteModelObserver.h"
#import "bixRemoteModelBase.h"

@interface bixSendMoodData : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassImageDelegate,UITextViewDelegate,bixRemoteModelObserver>
{

}

@property(nonatomic)int pictureNumber; //添加的图片数量;

@property(nonatomic) NSMutableArray *imageArray;

@property(strong,nonatomic) NSObject<PassImageDelegate> *delegate;

@property (strong, nonatomic) IBOutlet UITextView *textView;

//post分享圈的文字、图片后， 服务器会返回一些数据, 以notification的方式通知给本类，存在此字段;
@property (retain, nonatomic) NSMutableData  *theResultData;

@property(nonatomic,strong) UIImage *image1;

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;
@property (strong, nonatomic) IBOutlet UIImageView *imageView5;
@property (strong, nonatomic) IBOutlet UIImageView *imageView6;
@property (strong, nonatomic) IBOutlet UIImageView *imageView7;
@property (strong, nonatomic) IBOutlet UIImageView *imageView8;
@property (strong, nonatomic) IBOutlet UIImageView *imageView9;

@property (weak, nonatomic) UIButton *addPictureButton;

//- (IBAction)cancleSendMood:(id)sender;

- (void)addPicture;

- (IBAction)sendTextAndPicture:(id)sender;

- (IBAction)Tap:(id)sender;

@end
