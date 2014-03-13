//
//  Session.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface Session : NSObject

@property (nonatomic,retain) NSString* remoteJid;
@property (nonatomic,retain) NSMutableArray* msgs;

-(id) initWithRemoteJid:(NSString*) Jid;

@end
