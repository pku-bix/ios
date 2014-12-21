//
//  bixMomentDataItem.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "bixRemoteModelDelegate.h"
#import "bixImageProxy.h"

@interface bixMomentDataItem : bixRemoteModelBase<bixRemoteModelDelegate,bixRemoteModelDataSource>

// 用发送者初始化
- (id) initWithSender: (Account*) user;

-(void)push;

@property Account* sender;

// 分享文章、说说
@property (nonatomic) NSString* textContent;

// 回复
@property (nonatomic) NSMutableArray* replies;

// 发送的图片数组
@property (nonatomic) NSMutableArray *imageProxyArray;


@end
