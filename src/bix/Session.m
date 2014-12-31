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

@interface Session()
@property (nonatomic) unsigned int readMsgCount;
@end

@implementation Session

-(unsigned int) unReadMsgCount{
    return self.msgs.count - self.readMsgCount;
}

-(NSString*)peername{
    return self.peerAccount.username;
}

-(void) open{
    self.readMsgCount = self.msgs.count;
}

-(id) initWithRemoteAccount:(Account*) remoteAccount{
    self = [super init];
    if(self){
        self.peerAccount = remoteAccount;
        self.msgs = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self.peerAccount = [[bixChatProvider defaultChatProvider] getConcactByUsername:
                           (NSString*)[coder decodeObjectForKey:@"peer_username"]];
            
    if (self) {
        _msgs = [coder decodeObjectForKey:@"messages"];
        _readMsgCount = [coder decodeIntegerForKey:@"read_msgcount"];
        if (self.msgs == nil)
            self.msgs = [NSMutableArray array];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.peername forKey:@"peer_username"];
    [coder encodeObject:self.msgs forKey:@"messages"];
    [coder encodeInt:self.readMsgCount forKey:@"read_msgcount"];
}

- (bool)msgExpiredAt:(int)index{
    if(index <= 0)  return true;
    
    ChatMessage* mcurrent = [self.msgs objectAtIndex:index];
    ChatMessage* mlast = [self.msgs objectAtIndex:index - 1];
    NSTimeInterval interval = [mcurrent.date timeIntervalSinceDate:mlast.date];

    return interval > EXPIRE_TIME_INTERVAL;
}

@end
