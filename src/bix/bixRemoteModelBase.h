//
//  bixRemoteModelBase.h
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModelObserver.h"

@interface bixRemoteModelBase : NSObject

// 模型ID，唯一资源标识
@property (nonatomic) NSString* modelId;
// 观察者
@property id<bixRemoteModelObserver> observer;


-(id)initWithId:(NSString*)modelId;


-(void) connectionFailedWithError: (NSError*)err;
-(void) requestFailedWithError: (NSError*)err;
-(void) succeedWithStatus: (NSInteger) code;
-(void) SucceedWithStatus: (NSInteger) code andJSONResult: (NSObject*) result;


@end
