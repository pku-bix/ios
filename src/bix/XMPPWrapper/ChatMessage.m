//
//  ChatMessage.m
//  bix
//
//  Created by harttle on 14-3-14.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "ChatMessage.h"
#import "AppDelegate.h"

@implementation ChatMessage

@synthesize date;

// isMine property
-(BOOL) isMine{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    return [appdelegate.account.Jid.bare isEqualToString: self.from.bare];
}

// constructor
-(id)initWithBody:(NSString *)body From:(XMPPJID*)from To:(XMPPJID*)to{
    
    self = [super initWithType:@"chat" to:to];
    if(self){
        [self addBody:body];
        [self addAttributeWithName:@"from" stringValue: [from bare]];
        self.date = [NSDate date];
        
        //self.date = [self.date dateByAddingTimeInterval:-8*24*3600 +500];
    }
    return self;
}

-(id)initWithXMPPMessage:(XMPPMessage*)msg{
    self = [self initWithBody:msg.body From:msg.from To:msg.to];
    return self;
}

@end
