//
//  XMPPStream+Wrapper.m
//  Bix
//
//  Created by harttle on 14-3-11.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "XMPPStream.h"
#import "Account.h"

@interface XMPPStream (Wrapper)

//account
-(XMPPStream*)initWithAccount: (Account*)account;
-(Account*)getAccount;

//auto_auth
-(BOOL)getAuto_auth;
-(void)setAuto_auth:(BOOL)v;

//执行连接
-(BOOL)doConnect;
//重连，用于断线，连接后自动验证
-(BOOL)reconnect:(int)count;
//连接，用于注册，连接后不自动验证
-(BOOL)connect:(int)count;
//验证
-(void)authenticate;
//注册
-(BOOL) registerAccount;
//上线
-(void)goOnline;
//下线
-(void)goOffline;
//发送
-(void)send: (XMPPJID*)remoteJid Message:(NSString*)msgtxt;
//重发收件箱
-(void) resendAll: (XMPPStream*)sender;
@end
