//
//  DataWorker.m
//  bix
//
//  Created by harttle on 14-3-7.
//  Copyright (c) 2014年 bix. All rights reserved.
//


#import "DataWorker.h"
#import "Account.h"
#import "NSDate+Wrapper.h"
#import "Constants.h"
#import "xmpp.h"
#import "Message.h"
#import "Session.h"

@implementation DataWorker


-(id)init{
    self = [super init];
    
    self.contacts = [NSMutableArray array];
    self.sessions = [NSMutableArray array];
    
    return self;
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    
    // only chat message with body proceeds
    if (!message.isChatMessageWithBody) {
#ifdef DEBUG
        NSLog(@"message descarded:\n%@\n\n",message);
#endif
        return;
    }
    
    
    NSString *msgtxt = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    Message* msg = [[Message alloc] initWithMessageText: msgtxt isMine:false];
    
    NSArray* filteredSessions =[self.sessions
                       filteredArrayUsingPredicate:
                       [NSPredicate predicateWithFormat:@"remoteJid == %@",from]];
    
    Session* session;
    if (filteredSessions.count == 0) {
        session = [[Session alloc] initWithRemoteJid:from];
        [self.sessions addObject:session];
    }
    else{
        session = filteredSessions[0];
    }
    
    [session.msgs addObject:msg];

    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_RECEIVED object:msg ];
    

#ifdef DEBUG
    NSLog(@"message(%@) from %@:\n%@",message.type, from, msgtxt);
#endif

}




//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{

    //取得好友状态
    NSString *presenceType = [presence type]; //"available", "unavailable"
    //当前用户
    NSString *myJid = [[sender myJID] user];
    //在线用户
    NSString *remoteJid = [[presence from] user];
    
    if (![remoteJid isEqualToString:myJid]) {
        
        NSArray* filteredContacts =[self.contacts
                                    filteredArrayUsingPredicate:
                                    [NSPredicate predicateWithFormat:@"Jid == %@",remoteJid]];

        Account* remoteAccount;
        if (filteredContacts.count == 0) {
            remoteAccount = [[Account alloc] initWithJid:remoteJid];
            [self.contacts addObject:remoteAccount];
        }
        else{
            remoteAccount = filteredContacts[0];
        }
        
        remoteAccount.presence = [presenceType isEqual: @"available"];
        
        //发送通知
            
        [[NSNotificationCenter defaultCenter]
         postNotificationName:EVENT_BUDDY_PRESENCE
         object:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                 remoteAccount, @"account",
                 nil ]];
        
#ifdef DEBUG
        NSLog(@"presence received from %@: %@", remoteJid, presence);
#endif
        
    }
    else{
#ifdef DEBUG
        NSLog(@"presence descarded:\n%@\n\n",presence);
#endif
    }
}

@end
