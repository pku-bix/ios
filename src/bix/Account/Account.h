//
//  Account.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface Account : NSObject

@property (nonatomic,copy) NSString* password;

/*
@property (nonatomic,copy) NSString* address;
@property (nonatomic) NSString* username;
@property (nonatomic) NSString* servername;
@property (nonatomic) NSString* devicename;
@property (nonatomic) NSString* Jid;*/

@property (nonatomic,retain) XMPPJID* Jid;
@property (nonatomic) NSString* bareJid;

@property (nonatomic) int selectedTabIndex;
@property (nonatomic) BOOL autoLogin;
@property (nonatomic) BOOL presence;


-(id) init;
/*-(id) initWithAddr: (NSString*) addr;
-(id) initWithAddr: (NSString*) addr Password:(NSString*) password;
*/
-(id) initWithJid: (XMPPJID*) jid;
-(id) initWithJid: (XMPPJID*) jid Password:(NSString*) password;


- (void) save;
- (BOOL) isValid;

+ (Account*) loadDefault;

@end
