//
//  bixRemoteModelBase.h
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModelObserver.h"
#import "bixRemoteModelDelegate.h"

@interface bixRemoteModelBase : NSObject<bixRemoteModelDataSource,bixRemoteModelDelegate>

typedef void (^callback)(id<bixRemoteModelDataSource>);

// 模型ID，唯一资源标识
@property (nonatomic) NSString* modelId;
// 观察者
@property id<bixRemoteModelObserver> observer;
// 回调
@property (strong)callback cb;

-(void)pull;

-(id)initWithId:(NSString*)modelId;

-(void)modelUpdateComplete;



@end
