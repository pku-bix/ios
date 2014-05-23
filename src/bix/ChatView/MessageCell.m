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

@synthesize timeInfo;
@synthesize msgTextView;
@synthesize bgImageView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //时间标签
        timeInfo = [[UILabel alloc] initWithFrame:
                              CGRectMake(0,
                                         0,
                                         [UIScreen mainScreen].currentMode.size.width,
                                         TIMEINFO_HEIGHT)];
        timeInfo.font = [UIFont systemFontOfSize:11.0];
        timeInfo.textColor = [UIColor lightGrayColor];
        //timeInfo.adjustsFontSizeToFitWidth = false;
        timeInfo.textAlignment =  NSTextAlignmentCenter;
        //self.timeHidden = false;
        [self.contentView addSubview:timeInfo];
        
        //背景
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:bgImageView];
        
        //聊天信息
        msgTextView = [[UITextView alloc] init];
        msgTextView.backgroundColor = [UIColor clearColor];
        msgTextView.editable = NO;
        msgTextView.scrollEnabled = NO;
        
        //0 padding
        msgTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        msgTextView.textContainer.lineFragmentPadding = 0;
        
        [msgTextView setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:msgTextView];

    }
    
    return self;
    
}




@end
