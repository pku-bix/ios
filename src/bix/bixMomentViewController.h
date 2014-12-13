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

@interface bixMomentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, bixRemoteModelObserver>
{
    IBOutlet UIButton *btnSendMood;

}

@property (nonatomic) UIRefreshControl *refresh;

- (IBAction)sendMood:(id)sender;

@end
