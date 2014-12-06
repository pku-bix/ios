//
//  personInfoViewController.h
//  bix
//
//  Created by dsx on 14-10-13.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bixCaptureViewController.h"
#import "PassImageDelegate.h"
#import "bixRemoteModelObserver.h"

@interface personInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassImageDelegate,bixRemoteModelObserver>

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSArray *list2;

@end
