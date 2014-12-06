//
//  bixViewController.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassImageDelegate.h"
#import "bixRemoteModelObserver.h"
#import "bixRemoteModelDataSource.h"
#import "bixRemoteModelDelegate.h"

@interface bixMomentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, bixRemoteModelObserver,UIScrollViewDelegate>
{
    IBOutlet UIButton *btnSendMood;

}

@property (nonatomic) UIRefreshControl *refresh;
@property (retain, nonatomic) NSMutableData  *theResultData;//服务器返回的最新10条状态数据;
//@property(nonatomic)NSMutableArray * momentText; //保存每条状态的文字信息;

- (IBAction)sendMood:(id)sender;

@end
