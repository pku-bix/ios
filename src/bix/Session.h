//
//  Session.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface Session : NSObject<NSCoding>

@property (nonatomic,retain) XMPPJID* remoteJid;
@property (nonatomic,readonly) NSString* bareJid;

@property (nonatomic,retain) NSMutableArray* msgs;

-(id) initWithRemoteJid:(XMPPJID*) Jid;
-(bool) msgExpiredAt: (int) index;
@end
