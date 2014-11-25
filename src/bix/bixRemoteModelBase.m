//
//  bixRemoteModelBase.m
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixRemoteModelBase.h"

@implementation bixRemoteModelBase


-(id)initWithId:(NSString*)modelId{
    self = [super init];
    if(self){
        _modelId=modelId;
    }
    return self;
}


// 数据响应成功
-(void) SucceedWithStatus: (NSInteger) code andJSONResult: (NSObject*) result{
    
}

// 响应成功
-(void) succeedWithStatus: (NSInteger) code{
    
}

// 失败
-(void) requestFailedWithError: (NSError*)err{
#ifdef DEBUG
    NSLog(@"request failed with error: %@",err);
#endif
}

// 连接错误
-(void) connectionFailedWithError: (NSError*)err{
#ifdef DEBUG
    NSLog(@"connection failed with error: %@",err);
#endif
}


@end
