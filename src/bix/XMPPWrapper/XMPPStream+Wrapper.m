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


-(XMPPStream*)initWithAccount: (Account*)_account{
    self = [self init];
    account = _account;
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

-(BOOL)connect{
    
    self.myJID = account.Jid;
    self.hostName = SERVER;
    
    //连接服务器
    NSError *error = nil;
    return [self connectWithTimeout:CONNECT_TIMEOUT error: &error];
}

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

-(void) authenticate{
    NSError *error = nil;
    [self authenticateWithPassword:account.password error:&error];
}

-(void)send: (XMPPJID*)remoteJid Message:(NSString*)body{
    
    ChatMessage *msg = [[ChatMessage alloc] initWithBody:body From:self.myJID To:remoteJid];
    
    //发送消息
    [self sendElement:msg];
    
}

@end
