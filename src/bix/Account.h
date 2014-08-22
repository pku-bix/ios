//
//  Account.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface Account : NSObject<NSCoding>

@property (nonatomic) XMPPJID* Jid;
@property (nonatomic, readonly) NSString* bareJid;
@property (nonatomic) NSString* password;
@property (nonatomic) bool autoLogin;
@property (nonatomic) bool presence;
@property (readonly,getter = isValid) bool valid;

-(id) init;
-(id) initWithJid: (XMPPJID*) jid;
-(id) initWithJid: (XMPPJID*) jid Password:(NSString*) password;
-(id) initWithUsername: (NSString*)username Password:(NSString*) password;

- (bool) isValid;

/*
 * local storage
 */
- (void) save;
- (void) saveAsActiveUser;
+ (Account*) loadAccount: (NSString*)bareJid;
+ (NSString*) getActiveJid;

@end
