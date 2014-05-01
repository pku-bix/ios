//
//  Session.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "Session.h"
#import "Constants.h"

@implementation Session

-(NSString *)bareJid{
    return self.remoteJid.bare;
}

-(id) initWithRemoteJid:(XMPPJID*) Jid{
    self = [super init];
    if(self){
        self.remoteJid = Jid;
        self.msgs = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [self initWithRemoteJid:[XMPPJID jidWithString:
                                     (NSString*)[coder decodeObjectForKey:KEY_JID]]
            ];
            
    if (self) {
        
        self.msgs = [coder decodeObjectForKey:KEY_MESSAGE_LIST];
        if (self.msgs == nil) {
            self.msgs = [NSMutableArray array];
        }
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.bareJid forKey:KEY_JID];
    [coder encodeObject:self.msgs forKey:KEY_MESSAGE_LIST];
}

@end
