//
//  Account.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//
// 用户类，所有用户都应存储为一个Account对象。典型地，可用于通讯录中的联系人、朋友圈中的发送（回复）者、聊天中的对方。
// 对于本地用户，请参照 bixLocalAccount 类。
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "bixRemoteModelBase.h"
#import "bixRemoteModelDataSource.h"
#import "bixRemoteModelDelegate.h"
#import "bixRemoteModelObserver.h"

@interface Account : bixRemoteModelBase<NSCoding, bixRemoteModelDataSource, bixRemoteModelDelegate>

@property (nonatomic) bool presence;

@property (nonatomic) NSString* username;
@property (nonatomic) NSString* signature;
@property (nonatomic) NSString* wechatID;
@property (nonatomic) NSString* teslaType;
@property (nonatomic) NSString* nickname;
@property (nonatomic) NSString* avatar;

- (void) save;

- (id) initWithUsername: (NSString*)username;

+ (Account*) loadByUsername: (NSString*)username;

@end
