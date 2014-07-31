//
//  XMPPStream+Wrapper.m
//  Bix
//
//  Created by harttle on 14-3-11.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "XMPPStream+Wrapper.m"
#import "AppDelegate.h"
#import "Constants.h"
#import "ChatMessage.h"

@implementation XMPPStream (Wrapper)

Account* account;
int nRetry;

-(XMPPStream*)initWithAccount: (Account*)_account{
    self = [self init];
    account = _account;
    
    self.myJID = account.Jid;
    self.hostName = SERVER;
    
    return self;
}

//发送在线状态
-(void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence];
    [self sendElement:presence];
    account.presence = true;
}

//发送下线状态
-(void)goOffline{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self sendElement:presence];
    
}

// 连接
-(BOOL)connectWithRetry:(int)count{
    nRetry = count;
    return [self doConnect];
}

// 执行连接
-(BOOL)doConnect{
    if (nRetry > 0) {
        nRetry -- ;
        return [self connectWithTimeout:CONNECT_TIMEOUT error: nil];
    }
    else if (nRetry == -1){
        return [self connectWithTimeout:CONNECT_TIMEOUT error: nil];
    }
    return false;
}

// 注册
-(bool) registerAccount{
    NSError* error = nil;
    
    if([self registerWithPassword:account.password error:&error]){
        return true;
    }
    else{
        NSLog(@"register error: %@", error);
        return false;
    }
}

// 验证
-(void) authenticate{
    NSError *error = nil;
    [self authenticateWithPassword:account.password error:&error];
}

// 发送聊天
-(void)send: (XMPPJID*)remoteJid Message:(NSString*)body{
    ChatMessage *msg = [[ChatMessage alloc] initWithBody:body From:self.myJID To:remoteJid];
    [self sendElement:msg];
}

@end
