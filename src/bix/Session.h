//
//  Session.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "Account.h"

@interface Session : NSObject<NSCoding>

//@property (nonatomic) XMPPJID* remoteJid;


@property (weak) Account* peerAccount;
@property (nonatomic, readonly) NSString* peername;
@property (nonatomic) NSMutableArray* msgs;
@property (nonatomic, readonly) unsigned int unReadMsgCount;

-(id) initWithRemoteAccount:(Account*) remoteAccount;
-(bool) msgExpiredAt: (int) index;

// 打开会话
-(void) open;
@end
