//
//  bixMomentDataItem.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "bixRemoteModel.h"

@interface bixMomentDataItem : NSObject<bixRemoteModel>
{
    
}

// 用发送者初始化
- (id) initWithSender: (Account*) user;

- (bool) post;


// 头像
@property (readonly,nonatomic) NSURL* avatarUrl;
// 昵称, 用户在设置界面设置的   名字   字段;
@property (readonly,nonatomic) NSString* nickname;
// 分享文章、说说
@property (nonatomic) NSString* textContent;
// 分享图片, 做成NSUrl的类型，用户发送和从服务器拉取 统一成 NSUrl格式;
@property (nonatomic) NSMutableArray* imgUrls;
// 回复
@property (nonatomic) NSMutableArray* replies;



@end
