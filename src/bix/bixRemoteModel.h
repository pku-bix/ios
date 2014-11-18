//
//  bixRemoteModel.h
//  bix
//
//  Created by harttle on 11/18/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModelObserver.h"
//#import "bixRemoteSync.h"

@protocol bixRemoteModel <NSObject>

// 当模型变化时，通知该模型的观察者
@property id<bixRemoteModelObserver> observer;

// remotemodel delegate

//现在没有实现以下函数， 为了不产生warning, 先把以下函数设置为optional;
@optional

// 数据响应成功
-(void) SucceedWithStatus: (NSInteger) code andJSONResult: (NSObject*) result;

// 响应成功
-(void) succeedWithStatus: (NSInteger) code;

// 失败
-(void) failedWithError: (NSError*)err;

// remotemodel source

// 在API服务器模型的路径，eg：charger/ef131ab3f34133ab
-(NSString*) modelPath;

// PUSH请求的request body
-(NSData*) modelBody;



// 连接错误
-(void) connectionFailedWithError: (NSError*)err;


@end
