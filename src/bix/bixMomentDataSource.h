//
//  bixMomentDataSource.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixMomentDataItem.h"

@interface bixMomentDataSource : NSObject


// 该文件作为MomentDataItem的数据源，应借助HTTP层，实现MomentViewController需要的各种方法。

// 测试方法， 负责给bixMomentDataItem 传送account的 名字、头像字段
-(bixMomentDataItem*) getOneMoment;


@end
