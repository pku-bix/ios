//
//  bixAPIProvider.h
//  bix
//
//  Created by harttle on 11/18/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModelDelegate.h"
#import "bixRemoteModelDataSource.h"

// 提供 HTTP API 的原子操作
@interface bixAPIProvider : NSObject<NSURLConnectionDataDelegate>

// 远程模型
@property (nonatomic, weak) id<bixRemoteModelDelegate, bixRemoteModelDataSource> model;


// 上传
+(BOOL) Push: (id<bixRemoteModelDelegate, bixRemoteModelDataSource>) model;

// 下载
+(BOOL) Pull: (id<bixRemoteModelDelegate, bixRemoteModelDataSource>) model;

@end
