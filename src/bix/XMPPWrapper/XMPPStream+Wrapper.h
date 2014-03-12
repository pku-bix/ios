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

-(XMPPStream*)initWithAccount: (Account*)account;

//连接
-(BOOL)connect;
//验证
-(void)authenticate;
//上线
-(void)goOnline;
//下线
-(void)goOffline;

@end
