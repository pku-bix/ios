//
//  bixMomentDataSource.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixMomentDataItem.h"
#import "bixRemoteModel.h"

@interface bixMomentDataSource : NSObject

@property (nonatomic) id<bixRemoteModelObserver> observer;

//此数组保存添加的momentDataItem;
@property (nonatomic) NSMutableArray *momentDataItemsArray;

// singleton
+(bixMomentDataSource*) defaultSource;

// 该文件作为MomentDataItem的数据源，应借助HTTP层，实现MomentViewController需要的各种方法。

-(void)initMomentDataItemsArray;

// 测试方法， 负责给bixMomentDataItem 传送account的 名字、头像字段
-(bixMomentDataItem*) getOneMoment:(NSString *)text;

-(bixMomentDataItem*) getMomentAtIndex: (NSInteger) index;
// todo:  provide number

-(BOOL) addMomentDataItem: (bixMomentDataItem*)item;

-(int)numberOfMomentDataItem;

-(BOOL) update;

-(BOOL) loadMore;



@end
