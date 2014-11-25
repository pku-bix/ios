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

@interface bixAPIProvider : NSObject<NSURLConnectionDataDelegate>

// 远程模型
@property (nonatomic) id<bixRemoteModelDelegate, bixRemoteModelDataSource> model;


// 上传
+(bixAPIProvider*) Push: (id<bixRemoteModelDelegate, bixRemoteModelDataSource>) model;

// 下载
+(bixAPIProvider*) Pull: (id<bixRemoteModelDelegate, bixRemoteModelDataSource>) model;

@end
