//
//  bixCharger.m
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixCharger.h"

@implementation bixCharger


//现在没有实现以下函数， 为了不产生warning, 先把以下函数设置为optional;
//@optional

// 数据响应成功
-(void) SucceedWithStatus: (NSInteger) code andJSONResult: (NSObject*) result
{
    
}

// 响应成功
-(void) succeedWithStatus: (NSInteger) code
{
}

// 失败
-(void) failedWithError: (NSError*)err
{
}

// remotemodel source

// 在API服务器模型的路径，eg：charger/ef131ab3f34133ab
-(NSString*) modelPath
{
    return @"";
}

// PUSH请求的request body
-(NSData*) modelBody
{
    return NULL;
}



// 连接错误
-(void) connectionFailedWithError: (NSError*)err
{
}



@end
