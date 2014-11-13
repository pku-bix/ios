//
//  chargerInfoViewController.h
//  bix
//
//  Created by dsx on 14-10-23.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chargerInfoViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *mutableArray;

//经纬度
@property (strong, nonatomic) IBOutlet UITextField *coordinate;
//用户登入ID
@property (strong, nonatomic) IBOutlet UITextField *personID;
//充电桩详细地址
@property (strong, nonatomic) IBOutlet UITextField *detailAddr;
//提交按钮
@property (strong, nonatomic) IBOutlet UIButton *btnSubmitReport;
//电话
@property (strong, nonatomic) IBOutlet UITextField *telephone;
//邮箱
@property (strong, nonatomic) IBOutlet UITextField *email;
//备注
@property (strong, nonatomic) IBOutlet UITextField *remarks;
//充电桩数量
@property (strong, nonatomic) IBOutlet UITextField *parkingNum;

@property NSString* longitude;
@property NSString* latitude;

//用户点击界面其他部分时，软键盘自动关闭
- (IBAction)Tap:(id)sender;

//用户点击 上报 按钮， 提交上报的数据给后台
- (IBAction)reportDetailChargerInfo:(id)sender;


@end
