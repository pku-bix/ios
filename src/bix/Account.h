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

@interface Account : NSObject<NSCoding>

@property (nonatomic) XMPPJID* Jid;
@property (nonatomic, readonly, weak) NSString* bareJid;
@property (nonatomic, readonly, weak) NSString* username;
@property (nonatomic) bool presence;

//设置界面 ==> 个人信息页面
@property (nonatomic) NSString* setName;
@property (nonatomic) NSString* setSignature;
@property (nonatomic) NSString* setID;
@property (nonatomic) NSString* setWechatID;
@property (nonatomic) NSString* setTeslaType;

//头像保存
@property (nonatomic)UIImage * getHeadImage;

// TODO: @杜实现 上述属性为用户的内涵属性，需要重命名，替代以下属性：
@property (nonatomic) NSString* nickname;
@property (nonatomic) NSURL* avatarUrl;

- (id) initWithJid: (XMPPJID*) jid;
- (void) save;
+ (Account*) load: (NSString*)bareJid;

@end
