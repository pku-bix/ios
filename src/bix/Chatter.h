//
//  XMPPDelegate.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "Account.h"

@interface Chatter : NSObject

// 账号
@property (readonly, weak) Account* account;
// xmpp服务
@property XMPPStream *xmppStream;
// 发件箱
@property NSMutableArray *qsending;
// 自动验证
@property bool autoAuthentication;
// 联系人
@property (nonatomic, retain) NSMutableArray* contacts;
// 会话
@property (nonatomic, retain) NSMutableArray* sessions;

-(id)initWithAccount: (Account*)account;
-(void) saveContactsAndSessions;
-(void) loadContactsAndSessions;
-(void) logOut;
-(Account*)getConcact: (XMPPJID*)Jid;
-(Session*)getSession: (XMPPJID*)Jid;

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
-(void)send: (XMPPJID*)remoteJid Message:(NSString*)msgtxt;
//重发收件箱
-(void) resendAll: (XMPPStream*)sender;

@end
