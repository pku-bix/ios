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
#import "XMPPMessage+Wrapper.h"

@implementation XMPPStream (Wrapper)


Account* account;


-(XMPPStream*)initWithAccount: (Account*)_account{
    self = [self init];
    account = _account;
    return self;
}

-(void)goOnline{
    
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [self sendElement:presence];
    account.presence = true;
}

-(void)goOffline{
    
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self sendElement:presence];
    
}

-(BOOL)connect{
    
    //already connected
    if (![self isDisconnected]) {
        return YES;
    }
    
    //account illegal
    if (!account.isValid) {
        return NO;
    }
    
    self.myJID = account.Jid;
    self.hostName = SERVER;
    
    //连接服务器
    NSError *error = nil;
    if (![self connectWithTimeout:XMPPStreamTimeoutNone error: &error]) {
        return NO;
    }
    
    return YES;
}

-(NSString*) registerAccount{
    NSError* error = nil;
    
    if([self registerWithPassword:account.password error:&error]){
        return nil;
    }
    else{
        return @"error";
    }
}

-(void) authenticate{
    NSError *error = nil;
    [self authenticateWithPassword:account.password error:&error];
}

-(void)send: (XMPPJID*)remoteJid Message:(NSString*)body{
    
    XMPPMessage *msg = [[XMPPMessage alloc] initWithBody:body From:self.myJID To:remoteJid];
    
    //发送消息
    [self sendElement:msg];
    
}

@end
