//
//  Account.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
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
@property (nonatomic) NSString* setName;
@property (nonatomic) NSString* setSignature;
@property (nonatomic) NSString* setID;
@property (nonatomic) NSString* setWechatID;
@property (nonatomic) NSString* setTeslaType;

//头像保存
@property (nonatomic)UIImage * getHeadImage;

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
