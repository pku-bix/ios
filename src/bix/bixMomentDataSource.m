//
//  bixMomentDataSource.m
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixMomentDataSource.h"
#import "Account.h"

@implementation bixMomentDataSource

// TODO: 测试数据，完成HTTP层后删除
Account* account;

-(bixMomentDataItem*) getOneMoment{
    account = [Account new];
    account.nickname = @"杜实现";
    account.avatarUrl = [NSURL URLWithString: @"http://img0.bdstatic.com/img/image/shouye/mxlyfs-9632102318.jpg"];
    
    return [[bixMomentDataItem alloc] initWithSender:account];
}

@end
