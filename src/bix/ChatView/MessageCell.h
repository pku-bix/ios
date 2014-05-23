//
//  MessageCell.h
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell


@property(nonatomic, retain) UILabel *timeInfo;
@property(nonatomic, retain) UITextView *msgTextView;
@property(nonatomic, retain) UIImageView *bgImageView;

@end
