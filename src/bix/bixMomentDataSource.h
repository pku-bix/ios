//
//  bixMomentDataSource.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixMomentDataItem.h"
#import "bixRemoteModelObserver.h"
#import "bixAPIProvider.h"

@interface bixMomentDataSource : bixRemoteModelBase
// 该文件作为MomentDataItem的数据源，应借助HTTP层，实现MomentViewController需要的各种方法。

// singleton
+(bixMomentDataSource*) defaultSource;

-(bixMomentDataItem*) getMomentAtIndex: (NSInteger) index;

-(BOOL) addMomentDataItem: (bixMomentDataItem*)item;

-(BOOL) removeMomentDataItem:(int)index;

-(int)numberOfMomentDataItem;

-(BOOL) loadMore;



@end
