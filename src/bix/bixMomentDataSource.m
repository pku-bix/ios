//
//  bixMomentDataSource.m
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixMomentDataSource.h"
#import "Account.h"
#import "AppDelegate.h"

@implementation bixMomentDataSource
{
    AppDelegate *appDelegate;
    // TODO: 测试数据，完成HTTP层后删除
    Account* account;

}


-(bixMomentDataItem*) getOneMoment{
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    account = [appDelegate account];
    
//    account = [Account new];
//    account.nickname = @"杜实现";
    
    account.nickname = account.username;
    
    account.avatarUrl = [NSURL URLWithString: @"http://img0.bdstatic.com/img/image/shouye/mxlyfs-9632102318.jpg"];

//    account.avatarUrl = [NSURL URLWithString: @"http://image.tianjimedia.com/uploadImages/2013/231/Y86BKHJ2E2UH.jpg"];
    
    return [[bixMomentDataItem alloc] initWithSender:account];
}

@end
