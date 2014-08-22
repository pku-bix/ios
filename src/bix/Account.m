//
//  Account.m
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "Account.h"
#import "Constants.h"
#import "NSString+Account.h"
#import "Session.h"

@implementation Account

// propperties
- (bool) isValid{
    return [[self.Jid bare] isValidJid] && [self.password isValidPassword];
}


// methods

-(NSString *)bareJid{
    return self.Jid.bare;
}

-(id) init {
    return [self initWithJid:nil];
}

-(id) initWithJid: (XMPPJID*) jid{
    return [self initWithJid:jid Password:@""];
}

-(id) initWithJid: (XMPPJID*) jid Password:(NSString*) password{
    self = [super init];
    if(self)   {
        self.Jid = jid;
        self.password = password;
        
        // pre-init
        self.presence = NO;
    }
    return self;
}
-(id) initWithUsername:(NSString *)username Password:(NSString *)password{
    return [self initWithJid: [XMPPJID jidWithString: [username toJid]] Password:password];
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [self initWithJid:[XMPPJID jidWithString:
                              (NSString*)[coder decodeObjectForKey:KEY_JID]]
                    Password:(NSString*)[coder decodeObjectForKey:KEY_PASSWORD]];
    if (self) {
        self.autoLogin = [coder decodeBoolForKey:KEY_AUTOLOGIN];
    }
    return self;
}

- (void) saveAsActiveUser{
    [[NSUserDefaults standardUserDefaults] setObject:self.bareJid forKey:KEY_ACTIVE_JID];
}

- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // encoding
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:self.Jid.bare];
    
    // flush
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.Jid.bare forKey:KEY_JID];
    [coder encodeObject:self.password forKey:KEY_PASSWORD];
    [coder encodeBool:self.autoLogin forKey:KEY_AUTOLOGIN];
}

+ (Account*) loadAccount: (NSString*)bareJid{
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:bareJid];
    return data == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData: data];
}

+ (NSString*) getActiveJid{
    return [[NSUserDefaults standardUserDefaults] stringForKey: KEY_ACTIVE_JID];
}


@end
