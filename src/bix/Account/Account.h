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

@property (nonatomic, retain) NSMutableArray* contacts;


-(id) init;
/*-(id) initWithAddr: (NSString*) addr;
-(id) initWithAddr: (NSString*) addr Password:(NSString*) password;
*/
-(id) initWithJid: (XMPPJID*) jid;
-(id) initWithJid: (XMPPJID*) jid Password:(NSString*) password;


/*
 * query
 */
- (BOOL) isValid;
-(Account*)updateConcact: (XMPPJID*)Jid;


/*
 * local storage
 */
- (void) save;
//- (void) saveValue: (NSObject*)value InSessionWithKey:(NSString*)key;
//- (NSArray*) getStringArrayWithKey: (NSString*)key;
+ (Account*) loadDefault;


@end
