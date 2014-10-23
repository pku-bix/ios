//
//  chargerInfoViewController.h
//  bix
//
//  Created by dsx on 14-10-23.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chargerInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *coordinate;
@property (strong, nonatomic) IBOutlet UITextField *personID;
@property (strong, nonatomic) IBOutlet UITextField *detailAddr;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmitReport;

@property (strong, nonatomic) IBOutlet UITextField *telephone;

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *remarks;
@property (strong, nonatomic) IBOutlet UITextField *parkingNum;


@end
