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


@property (weak) Account* remoteAccount;
@property (nonatomic, readonly) NSString* bareJid;
@property (nonatomic) NSMutableArray* msgs;

-(id) initWithRemoteAccount:(Account*) remoteAccount;
-(bool) msgExpiredAt: (int) index;
@end
