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

// isMine property
-(bool) isMine{
    
    return [[bixLocalAccount instance].username isEqualToString: self.from.user];
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

- (id)initWithCoder:(NSCoder *)coder {
    self=[super initWithCoder:coder];
    
    if (self) {
        self.date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.date forKey:@"date"];
}


@end
