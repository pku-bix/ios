//
//  bixMomentDataItem.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface bixMomentDataItem : NSObject
{
//    int test;
}

// 用发送者初始化
- (id) initWithSender: (Account*) user;


// 头像
@property (readonly,nonatomic) NSURL* avatarUrl;
// 昵称, 用户在设置界面设置的   名字   字段;
@property (readonly,nonatomic) NSString* nickname;
// 分享文章、说说
@property (nonatomic) NSString* textContent;
// 分享图片
@property (nonatomic) NSMutableArray* imgUrls;
// 回复
@property (nonatomic) NSMutableArray* replies;

@end
