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
    
    //设置用户
    self.myJID = [XMPPJID jidWithString:account.Jid];
                  
    //设置服务器
    self.hostName = SERVER;
    
    
    //连接服务器
    NSError *error = nil;
    if (![self connectWithTimeout:XMPPStreamTimeoutNone error: &error]) {
        return NO;
    }
    
    return YES;
}

-(void) authenticate{
    NSError *error = nil;
    [self authenticateWithPassword:account.password error:&error];
}

@end
