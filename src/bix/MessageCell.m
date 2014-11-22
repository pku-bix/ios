//
//  MessageCell.m
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MessageCell.h"
#import "Constants.h"

@implementation MessageCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)MessageCellReuseID{
    
    self = [super initWithStyle:style reuseIdentifier:MessageCellReuseID];
    if (self) {
        //时间标签
        _timeInfo = [[UILabel alloc] initWithFrame:
                              CGRectMake(0,
                                         0,
                                         [UIScreen mainScreen].currentMode.size.width,
                                         TIMEINFO_HEIGHT)];
        _timeInfo.font = [UIFont systemFontOfSize:11.0];
        _timeInfo.textColor = [UIColor lightGrayColor];
        //timeInfo.adjustsFontSizeToFitWidth = false;
        _timeInfo.textAlignment =  NSTextAlignmentCenter;
        //self.timeHidden = false;
        [self.contentView addSubview:_timeInfo];
        
        //背景
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_bgImageView];
        
        //聊天头像
        _chatHeadShow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_chatHeadShow];
        
        //聊天信息
        _msgTextView = [[UITextView alloc] init];
        _msgTextView.backgroundColor = [UIColor clearColor];
        _msgTextView.editable = NO;
        _msgTextView.scrollEnabled = NO;
        
        //0 padding
        _msgTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _msgTextView.textContainer.lineFragmentPadding = 0;
        
        [_msgTextView setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_msgTextView];

    }
    
    return self;
    
}




@end
