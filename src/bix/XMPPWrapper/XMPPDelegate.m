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


-(id)init{
    self = [super init];
        
    return self;
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

    // generate chatMessage
    ChatMessage *chatMessage = [[ChatMessage alloc] initWithBody:message.body From:message.from To:message.to];
    
    Session* session = [self.account getSession:chatMessage.from];
    [session.msgs addObject:chatMessage];
    
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
    
    Account* remoteAccount = [self.account getConcact:remoteJid];
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
    Session* session = [self.account getSession:message.to];
    ChatMessage* chatMessage = [[ChatMessage alloc] initWithXMPPMessage:message];
    [session.msgs addObject:chatMessage];

    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_SENT object:chatMessage ];
    return chatMessage;
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

// 连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmppstream did connect");
#endif
}

//连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmppstream connect timeout");
#endif
}

// 断开连接成功
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmppstream did disconnect");
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DISCONNECTED object:self];
}

// 验证成功
- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmppstream did authenticate");
#endif
}

// 验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
#ifdef DEBUG
    NSLog(@"xmppstream did not authenticate");
#endif
}
@end
