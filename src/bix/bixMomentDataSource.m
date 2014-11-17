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

//设置account的nickname和avatarUrl两个属性;
-(bixMomentDataItem*) getOneMoment:(NSString*)text{
//    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    account = [[AppDelegate get] account];
//    account = [Account new];
//    account.nickname = @"杜实现";
    account.momentText = text;
    
    NSLog(@"bixMomentDataSource.h, account.setName is %@", account.setName);
    //如果用户在设置界面没有设置名字字段，则显示用户名，否则显示用户设置的名字字段---昵称;
    //判断字符串是否为空 string == nil;
    if (account.setName == nil) { //如果用户没有在设置界面设置   名字   字段，则显示用户名;
        account.nickname = account.username;
        NSLog(@"bixMomentDataSource.h, account.username is %@", account.username);
    }
    else
    {
//        account.nickname = account.setName ;  //否则显示设置的    名字
        account.nickname = account.username;
        NSLog(@"bixMomentDataSource.h, account.setName is %@", account.setName);
    }
    
    account.avatarUrl = [NSURL URLWithString: @"http://img0.bdstatic.com/img/image/shouye/mxlyfs-9632102318.jpg"];

//    account.avatarUrl = [NSURL URLWithString: @"http://image.tianjimedia.com/uploadImages/2013/231/Y86BKHJ2E2UH.jpg"];
    
    bixMomentDataItem *item = [[bixMomentDataItem alloc] initWithSender:account];
    item.textContent = @"hehehehehehehehehfdsafdsaf";
    return item;
}

@end
