//
//  ChatMessage.h
//  bix
//
//  Created by harttle on 14-3-14.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "XMPPFramework.h"
#import "Account.h"
#import "NSDate+Wrapper.h"


@interface ChatMessage: XMPPMessage<NSCoding>

@property (nonatomic) NSDate* date;
@property (nonatomic,readonly) bool isMine;

-(id)initWithBody:(NSString *)body From:(XMPPJID*)from To:(XMPPJID*)to;
-(id)initWithXMPPMessage:(XMPPMessage*)msg;

@end
