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

@property (nonatomic,retain) XMPPJID* Jid;
@property (nonatomic, readonly) NSString* bareJid;
@property (nonatomic,copy) NSString* password;
@property (nonatomic) BOOL autoLogin;
@property (nonatomic) BOOL presence;

@property (nonatomic, retain) NSMutableArray* contacts;
@property (nonatomic, retain) NSMutableArray* sessions;


-(id) init;
-(id) initWithJid: (XMPPJID*) jid;
-(id) initWithJid: (XMPPJID*) jid Password:(NSString*) password;
-(id) initWithUsername: (NSString*)username Password:(NSString*) password;


/*
 * query
 */
- (BOOL) isValid;
-(Account*)getConcact: (XMPPJID*)Jid;
-(Session*)getSession: (XMPPJID*)Jid;

/*
 * local storage
 */
- (void) save;
- (void) clearAll;
+ (Account*) loadAccount: (NSString*)bareJid;
+ (Account*) loadDefault;


@end
