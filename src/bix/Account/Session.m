//
//  Session.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "Session.h"

@implementation Session

-(id) initWithRemoteJid:(NSString*) Jid{
    self = [super init];
    if(self){
        self.remoteJid = Jid;
        self.msgs = [NSMutableArray array];
    }
    return self;
}

@end
