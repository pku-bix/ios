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
bool auto_auth;

-(BOOL)getAuto_auth{
    return auto_auth;
}
-(void)setAuto_auth:(BOOL)v{
    auto_auth = v;
}

-(XMPPStream*)initWithAccount: (Account*)_account{
    self = [self init];
    account = _account;
    
    self.myJID = account.Jid;
    self.hostName = SERVER;
    
    return self;
}

-(Account*)getAccount{
    return account;
}

-(void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence];
    [self sendElement:presence];
    account.presence = true;
}

-(void)goOffline{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self sendElement:presence];
    account.presence = false;
}

-(BOOL)reconnect:(int)count{
    nRetry = count;
    auto_auth = true;
    return [self doConnect];
}

-(BOOL)connect:(int)count{
    nRetry = count;
    auto_auth = false;
    return [self doConnect];
}

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
    [self sendElement:msg];
}

@end
