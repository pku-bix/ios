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

@implementation DataWorker


-(id)init{
    self = [super init];
    
    self.contacts = [NSMapTable strongToStrongObjectsMapTable];
    self.sessions = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    
    // only chat message with body proceeds
    if (!message.isChatMessageWithBody) {
        return;
    }
    
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    
#ifdef DEBUG
    NSLog(@"message(%@) from %@:\n%@",message.type, from, msg);
#endif
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"msg"];
    [dict setObject:from forKey:@"sender"];
    [dict setObject:[NSDate getCurrentTime] forKey:@"time"];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_RECEIVED object:dict ];
}




//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{

    //取得好友状态
    NSString *presenceType = [presence type]; //"available", "unavailable"
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //发送通知
            
        [[NSNotificationCenter defaultCenter]
         postNotificationName:EVENT_BUDDY_PRESENCE
         object:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                 presenceType, EVENT_BUDDY_PRESENCE,
                 presenceFromUser, @"user",
                 nil ]];
        
#ifdef DEBUG
        NSLog(@"presence received from %@: %@", presenceFromUser, presence);
#endif
        
    }
}

@end
