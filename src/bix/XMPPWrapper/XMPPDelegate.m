//
//  XMPPDelegate.m
//  bix
//
//  Created by harttle on 14-3-7.
//  Copyright (c) 2014年 bix. All rights reserved.
//


#import "XMPPDelegate.h"
#import "Account.h"
#import "NSDate+Wrapper.h"
#import "Constants.h"
#import "xmpp.h"
#import "Session.h"
#import "NSString+Account.h"
#import "XMPPMessage+Wrapper.h"

@implementation XMPPDelegate


-(id)init{
    self = [super init];
    
    self.contacts = [NSMutableArray array];
    self.sessions = [NSMutableArray array];
    
    return self;
}


//query contact, add when needed
-(Account*)updateConcact: (XMPPJID*)Jid{
    NSArray* filteredContacts =[self.contacts
                                filteredArrayUsingPredicate:
                                [NSPredicate predicateWithFormat:@"bareJid == %@",Jid.bare]];
    
    Account* account;
    if (filteredContacts.count == 0) {
        account = [[Account alloc] initWithJid:Jid];
        [self.contacts addObject:account];
    }
    else{
        account = filteredContacts[0];
    }
    account.Jid = Jid; // update Jid, resource especially
    return account;
}

//query session, add when needed
-(Session*)updateSession: (XMPPJID*)Jid{
    
    NSArray* filteredSessions =[self.sessions
                                filteredArrayUsingPredicate:
                                [NSPredicate predicateWithFormat:@"bareJid == %@",Jid.bare]];
    
    Session* session;
    if (filteredSessions.count == 0) {
        session = [[Session alloc] initWithRemoteJid:Jid];
        [self.sessions addObject:session];
    }
    else{
        session = filteredSessions[0];
    }
    session.remoteJid = Jid;
    return session;
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
#ifdef DEBUG
    NSLog(@"message received:\n%@\n\n",message);
#endif

    // only chat message with body proceeds
    if (!message.isChatMessageWithBody) {
        return;
    }

    // set date
    message.time = [NSDate date];
    
    Session* session = [self updateSession:message.from];
    [session.msgs addObject:message];

    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_RECEIVED object:self ];
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    
#ifdef DEBUG
    NSLog(@"presence received:\n%@\n\n", presence);
#endif
    
    //取得好友状态
    NSString *presenceType = [presence type]; //"available", "unavailable"
    //当前用户
    XMPPJID *myJid = [sender myJID];
    //在线用户
    XMPPJID *remoteJid = [presence from];
    
    Account* remoteAccount = [self updateConcact:remoteJid];
    remoteAccount.presence = [presenceType isEqual: @"available"];
    
    if (![remoteJid.bare isEqualToString:myJid.bare]) {
        //发送通知
            
        [[NSNotificationCenter defaultCenter]
         postNotificationName:EVENT_BUDDY_PRESENCE
         object:self
         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                 remoteAccount, @"account",
                 nil ]];
    }
}

//收到错误信息
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error{
    
#ifdef DEBUG
    NSLog(@"error received:\n%@\n\n",error);
#endif
    
}



//将要发送IQ
- (XMPPIQ *)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq{
    return iq;
}

//将要发送信息
- (XMPPMessage *)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message{
    Session* session = [self updateSession:message.to];
    [session.msgs addObject:message];

    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_SENT object:message ];
    return message;
}

//将要发送在线状态
- (XMPPPresence *)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence{
    return presence;
}


//已发送IQ
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
    
#ifdef DEBUG
    NSLog(@"send iq succeed:\n%@\n\n",iq);
#endif
}

//已发送信息
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    
#ifdef DEBUG
    NSLog(@"send message succeed:\n%@\n\n",message);
#endif
}

//已发送在线状态
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{
    
#ifdef DEBUG
    NSLog(@"send presence succeed:\n%@\n\n",presence);
#endif
}


//发送IQ失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error{
    
#ifdef DEBUG
    NSLog(@"send iq failed error: %@\niq:\n%@\n\n",error,iq);
#endif
}

//发送信息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{

#ifdef DEBUG
    NSLog(@"send message failed error: %@\nmessage:\n%@\n\n",error,message);
#endif
}

//发送在线状态失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error{
    
#ifdef DEBUG
    NSLog(@"send presence failed error: %@\npresence:\n%@\n\n",error,presence);
#endif
}

@end
