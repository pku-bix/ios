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
#import "ChatMessage.h"
#import "XMPPStream+Wrapper.h"

@implementation XMPPDelegate

// 发件箱
NSMutableArray *qsending;


-(id)init{
    self = [super init];
    qsending = [NSMutableArray new];
    return self;
}

// 重发
-(void) resendAll: (XMPPStream*)sender{
    while(qsending.count>0) {
        [sender sendElement:qsending.firstObject];
        [qsending removeObjectAtIndex:0];
    }
}

// 连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmppstream connected");
#endif
    // 验证
    if (!sender.isAuthenticated && !sender.isAuthenticating) {
        [sender authenticate];
    }
    // 重发
    if(sender.isAuthenticated){
        [self resendAll:sender];
    }
}
// 连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmppstream connect timeout");
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DISCONNECTED object:self];
    [sender doConnect];
}
// 断开连接成功
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmppstream disconnect");
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DISCONNECTED object:self];
}

// 验证成功
- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmppstream authenticated");
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_AUTHENTICATED object:self];
    [self resendAll:sender];
}
// 验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
#ifdef DEBUG
    NSLog(@"xmppstream authenticate failed");
#endif    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_AUTHENTICATE_FAILED object:self];
}


//将要发送状态
- (XMPPPresence *)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence{
#ifdef DEBUG
    NSLog(@"xmpp will send presence\n%@\n\n",presence);
#endif
    return presence;
}
//已发送状态
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{
#ifdef DEBUG
    NSLog(@"xmpp sent presence:\n%@\n\n",presence);
#endif
}
//发送状态失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmpp send presence failed, error: %@\npresence:\n%@\n\n",error,presence);
#endif
    if (error.code == XMPPStreamInvalidState && error.domain==XMPPStreamErrorDomain) {
        [sender connectWithRetry:-1];
        [qsending addObject:presence];
#ifdef DEBUG
        NSLog(@"state invalid, reconnecting...");
#endif
    }
}
//收到状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
#ifdef DEBUG
    NSLog(@"xmpp presence received:\n%@\n\n", presence);
#endif
    //取得好友状态
    NSString *presenceType = [presence type]; //"available", "unavailable"
    //当前用户
    XMPPJID *myJid = [sender myJID];
    //在线用户
    XMPPJID *remoteJid = [presence from];
    
    Account* remoteAccount = [self.account getConcact:remoteJid];
    remoteAccount.presence = [presenceType isEqual: @"available"];
    
    if (![remoteJid.bare isEqualToString:myJid.bare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BUDDY_PRESENCE object:self
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    remoteAccount, @"account", nil ]];
    }
}

//将要发送聊天
- (XMPPMessage *)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message{
    Session* session = [self.account getSession:message.to];
    ChatMessage* chatMessage = [[ChatMessage alloc] initWithXMPPMessage:message];
    [session.msgs addObject:chatMessage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_SENT object:chatMessage ];
    return chatMessage;
}
//已发送聊天
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
#ifdef DEBUG
    NSLog(@"xmpp sent message:\n%@\n\n",message);
#endif
}
//发送聊天失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmpp send message failed: %@\nmessage:\n%@\n\n",error,message);
#endif
    if (error.code == XMPPStreamInvalidState && error.domain==XMPPStreamErrorDomain) {
        [sender connectWithRetry:-1];
        [qsending addObject:message];
#ifdef DEBUG
        NSLog(@"state invalid, reconnecting...");
#endif
    }
}
//收到聊天
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
#ifdef DEBUG
    NSLog(@"xmpp message received:\n%@\n\n",message);
#endif
    // only chat message with body proceeds
    if (!message.isChatMessageWithBody) {
        return;
    }
    
    // generate chatMessage
    ChatMessage *chatMessage = [[ChatMessage alloc] initWithBody:message.body From:message.from To:message.to];
    
    Session* session = [self.account getSession:chatMessage.from];
    [session.msgs addObject:chatMessage];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_RECEIVED object:self ];
}


//将要发送IQ
- (XMPPIQ *)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq{
#ifdef DEBUG
    NSLog(@"xmpp will send iq:\n%@\n\n",iq);
#endif
    return iq;
}
//已发送IQ
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
#ifdef DEBUG
    NSLog(@"xmpp send iq succeed:\n%@\n\n",iq);
#endif
}
//发送IQ失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmpp send iq failed: %@\niq:\n%@\n\n",error,iq);
#endif
    if (error.code == XMPPStreamInvalidState && error.domain==XMPPStreamErrorDomain) {
        [sender connectWithRetry:-1];
        [qsending addObject:iq];
#ifdef DEBUG
        NSLog(@"state invalid, reconnecting...");
#endif
    }
}


//收到错误信息
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error{
#ifdef DEBUG
    NSLog(@"xmpp error received:\n%@\n\n",error);
#endif
}


@end
