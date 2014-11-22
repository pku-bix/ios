//
//  XMPPDelegate.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixLocalAccount.h"
#import "Session.h"

@interface ChatProvider : NSObject

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


-(id) initWithAccount: (bixLocalAccount*)account;
// be sure chatter inited and mounted when calling this
-(void) loadData;
-(void) saveData;

-(void) saveContactsAndSessions;
-(void) loadContactsAndSessions;
-(void) logOut;
-(Account*)getConcact: (NSString*)bareJid;
-(Session*)getSession: (Account*)remoteAccount;

//执行连接
-(BOOL)doConnect;
//重连，用于断线，连接后自动验证
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
