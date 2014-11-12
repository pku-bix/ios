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
@property (nonatomic) NSString* password;
@property (nonatomic) bool autoLogin;
@property (nonatomic) bool presence;
@property (readonly,getter = isValid) bool valid;

//设置界面 ==> 个人信息页面
@property (nonatomic) NSString* setName;  //用户自己设置的  名字  字段；
@property (nonatomic) NSString* setSignature;
@property (nonatomic) NSString* setID;
@property (nonatomic) NSString* setWechatID;
@property (nonatomic) NSString* setTeslaType;

//头像保存
@property (nonatomic)UIImage * getHeadImage;

// TODO: 上述属性为用户的内涵属性，需要重命名，替代以下属性：
@property (nonatomic) NSString* nickname;
@property (nonatomic) NSURL* avatarUrl;

-(id) init;
-(id) initWithJid: (XMPPJID*) jid;
-(id) initWithJid: (XMPPJID*) jid Password:(NSString*) password;
-(id) initWithUsername: (NSString*)username Password:(NSString*) password;

- (bool) isValid;

/*
 * local storage
 */
- (void) save;
- (void) saveAsActiveUser;
+ (Account*) loadAccount: (NSString*)bareJid;
+ (NSString*) getActiveJid;

@end
