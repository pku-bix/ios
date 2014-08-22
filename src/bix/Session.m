//
//  Session.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "Session.h"
#import "ChatMessage.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation Session

-(NSString *)bareJid{
    return self.remoteAccount.bareJid;
}

-(id) initWithRemoteAccount:(Account*) remoteAccount{
    self = [super init];
    if(self){
        self.remoteAccount = remoteAccount;
        self.msgs = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    AppDelegate* appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.remoteAccount = [appdelegate.chatter getConcact:
                           (NSString*)[coder decodeObjectForKey:KEY_JID]];
            
    if (self) {
        self.msgs = [coder decodeObjectForKey:KEY_MESSAGE_LIST];
        if (self.msgs == nil)
            self.msgs = [NSMutableArray array];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.bareJid forKey:KEY_JID];
    [coder encodeObject:self.msgs forKey:KEY_MESSAGE_LIST];
}

- (bool)msgExpiredAt:(int)index{
    if(index <= 0)  return true;
    
    ChatMessage* mcurrent = [self.msgs objectAtIndex:index];
    ChatMessage* mlast = [self.msgs objectAtIndex:index - 1];
    NSTimeInterval interval = [mcurrent.date timeIntervalSinceDate:mlast.date];

    return interval > EXPIRE_TIME_INTERVAL;
}

@end
