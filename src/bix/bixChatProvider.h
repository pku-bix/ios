//
//  XMPPDelegate.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixLocalAccount.h"
#import "Session.h"

@interface bixChatProvider : NSObject

// 账号
@property (readonly, weak) bixLocalAccount* account;
// xmpp服务
@property XMPPStream *xmppStream;
// 发件箱
@property NSMutableArray *qsending;
// 自动验证
@property bool autoAuthentication;
// 联系人
@property (nonatomic) NSMutableArray* contacts;
// 会话
@property (nonatomic) NSMutableArray* sessions;


+(bixChatProvider*)defaultChatProvider;
+(void)setLocalAccount:(bixLocalAccount*) account;
+ (void) save;
+ (void) reconnect;

-(Account*)getConcactByUsername: (NSString*)username;
-(Session*)getSession: (Account*)remoteAccount;
-(void) save;
-(void) load;

//执行连接
-(BOOL)doConnect;
//退出登录
-(void) logOut;
//重连，用于断线，连接后自动验证
-(void)goOffline;
-(void)goOnline;
-(BOOL)keepConnectedAndAuthenticated:(int)count;
//连接，用于注册，连接后不自动验证
-(BOOL)keepConnected:(int)count;
//验证
-(void)authenticate;
//注册
-(BOOL) registerAccount;
//发送
-(void)send: (Account*)remoteAccount Message:(NSString*)body;
//重发收件箱
-(void) resendAll: (XMPPStream*)sender;

@end
