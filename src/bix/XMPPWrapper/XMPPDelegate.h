//
//  XMPPDelegate.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "Session.h"

@interface XMPPDelegate : NSObject 

@property (nonatomic, retain) NSMutableArray* contacts;
@property (nonatomic, retain) NSMutableArray* sessions;

-(id)init;
-(Session*)updateSession: (XMPPJID*)Jid;

@end
