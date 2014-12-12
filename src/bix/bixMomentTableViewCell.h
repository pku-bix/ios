//
//  bixMomentTableViewCell.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bixMomentDataItem.h"

@interface bixMomentTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

- (void) loadFromMomentDataItem:(bixMomentDataItem*)item;

// 用户头像
@property (nonatomic, retain) IBOutlet UIImageView *userImageView;
// 用户显示名
@property (retain, nonatomic) IBOutlet UILabel *userLabel;
// 分享文本内容
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
// 分享图片组
@property (retain, nonatomic) IBOutlet UICollectionView *imgCollectionView;
// 回复列表
@property (weak, nonatomic) IBOutlet UITableView *replyTableView;

@end