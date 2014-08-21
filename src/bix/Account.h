//
//  Account.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "Session.h"

@interface Account : NSObject<NSCoding>

@property (nonatomic) XMPPJID* Jid;
@property (nonatomic, readonly) NSString* bareJid;
@property (nonatomic) NSString* password;
@property (nonatomic) BOOL autoLogin;
@property (nonatomic) BOOL presence;
@property (readonly,getter = isValid) BOOL valid;

-(id) init;
-(id) initWithJid: (XMPPJID*) jid;
-(id) initWithJid: (XMPPJID*) jid Password:(NSString*) password;
-(id) initWithUsername: (NSString*)username Password:(NSString*) password;

- (BOOL) isValid;

/*
 * local storage
 */
- (void) save;
- (void) saveAsActiveUser;
+ (Account*) loadAccount: (NSString*)bareJid;
+ (NSString*) getActiveJid;

@end
