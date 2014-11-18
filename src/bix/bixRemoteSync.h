//
//  bixRemoteSync.h
//  bix
//
//  Created by harttle on 11/18/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModel.h"

@interface bixRemoteSync : NSObject<NSURLConnectionDataDelegate>

// 远程模型
@property (nonatomic) id<bixRemoteModel> model;


// 上传
-(bool) Push: (id<bixRemoteModel>) model;

// 下载
-(bool) Pull: (id<bixRemoteModel>) model;

@end
