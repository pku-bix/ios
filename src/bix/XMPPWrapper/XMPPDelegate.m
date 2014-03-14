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
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_RECEIVED object:message ];
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
         object:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                 remoteAccount, @"account",
                 nil ]];
    }
}

/**
 * These methods are called before their respective XML elements are sent over the stream.
 * These methods can be used to modify outgoing elements on the fly.
 * (E.g. add standard information for custom protocols.)
 *
 * You may also filter outgoing elements by returning nil.
 *
 * When implementing these methods to modify the element, you do not need to copy the given element.
 * You can simply edit the given element, and return it.
 * The reason these methods return an element, instead of void, is to allow filtering.
 *
 * Concerning thread-safety, delegates implementing the method are invoked one-at-a-time to
 * allow thread-safe modification of the given elements.
 *
 * You should NOT implement these methods unless you have good reason to do so.
 * For general processing and notification of sent elements, please use xmppStream:didSendX: methods.
 *
 * @see xmppStream:didSendIQ:
 * @see xmppStream:didSendMessage:
 * @see xmppStream:didSendPresence:
 **/

- (XMPPIQ *)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq{
    return iq;
}
- (XMPPMessage *)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message{
    Session* session = [self updateSession:message.to];
    [session.msgs addObject:message];

    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_SENT object:message ];
    return message;
}
- (XMPPPresence *)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence{
    return presence;
}


/**
 * These methods are called after their respective XML elements are sent over the stream.
 * These methods may be used to listen for certain events (such as an unavailable presence having been sent),
 * or for general logging purposes. (E.g. a central history logging mechanism).
 **/
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
    
#ifdef DEBUG
    NSLog(@"send iq succeed:\n%@\n\n",iq);
#endif
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    
#ifdef DEBUG
    NSLog(@"send message succeed:\n%@\n\n",message);
#endif
}

- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{
    
#ifdef DEBUG
    NSLog(@"send presence succeed:\n%@\n\n",presence);
#endif
}

/**
 * These methods are called after failing to send the respective XML elements over the stream.
 **/
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error{
    
#ifdef DEBUG
    NSLog(@"send iq failed error: %@\niq:\n%@\n\n",error,iq);
#endif
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{

#ifdef DEBUG
    NSLog(@"send message failed error: %@\nmessage:\n%@\n\n",error,message);
#endif
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error{
    
#ifdef DEBUG
    NSLog(@"send presence failed error: %@\npresence:\n%@\n\n",error,presence);
#endif
}

/**
 * This method is called if an XMPP error is received.
 * In other words, a <stream:error/>.
 *
 * However, this method may also be called for any unrecognized xml stanzas.
 *
 * Note that standard errors (<iq type='error'/> for example) are delivered normally,
 * via the other didReceive...: methods.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error{
    
#ifdef DEBUG
    NSLog(@"error received:\n%@\n\n",error);
#endif

}

@end
