//
//  bixRemoteModel.h
//  bix
//
//  Created by harttle on 11/18/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModelObserver.h"

@protocol bixRemoteModelDelegate <NSObject>

@optional

// 数据相应成功
-(void) populateWithJSON: (NSObject*) result;
-(void) succeedWithStatus: (NSInteger) code andJSON: (NSObject*) result;

// 响应成功
-(void) succeedWithStatus: (NSInteger) code;

// 失败
-(void) requestFailedWithError: (NSError*)err;

// 连接错误
-(void) connectionFailedWithError: (NSError*)err;

@end
