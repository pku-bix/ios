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
        self.contacts = [NSMutableArray array];
        self.sessions = [NSMutableArray array];
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
        
        if ([coder containsValueForKey:KEY_CONTACT_LIST]) {
            self.contacts = [coder decodeObjectForKey:KEY_CONTACT_LIST];
        }
        if ([coder containsValueForKey:KEY_SESSION_LIST]) {
            self.sessions = [coder decodeObjectForKey:KEY_SESSION_LIST];
        }
    }
    return self;
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
    
    [coder encodeObject:self.contacts forKey:KEY_CONTACT_LIST];
    [coder encodeObject:self.sessions forKey:KEY_SESSION_LIST];
}

+ (Account*) loadAccount: (NSString*)bareJid{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [defaults objectForKey:bareJid];
    
    return data == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData: data];
}

+ (Account*) loadDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* bareJid = [defaults stringForKey: KEY_ACTIVE_JID];
    
    return bareJid == nil ? nil : [Account loadAccount:bareJid];
}

//query contact, add when needed
-(Account*)getConcact: (XMPPJID*)Jid{
    
    // self query
    if([self.Jid.bare isEqualToString: Jid.bare]) return self;
    
    NSArray* filteredContacts =[self.contacts
                                filteredArrayUsingPredicate:
                                [NSPredicate predicateWithFormat:@"bareJid == %@",Jid.bare]];
    
    Account* account;
    if (filteredContacts.count == 0) {
        account = [[Account alloc] initWithJid:Jid];
        [self.contacts addObject:account];
        
        //notify
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CONTACT_ADDED object:self ];
    }
    else{
        account = filteredContacts[0];
    }
    account.Jid = Jid; // update Jid, resource especially
    return account;
}


//query session, add when needed
-(Session*)getSession: (XMPPJID*)Jid{
    
    NSArray* filteredSessions =[self.sessions
                                filteredArrayUsingPredicate:
                                [NSPredicate predicateWithFormat:@"bareJid == %@",Jid.bare]];
    
    Session* session;
    if (filteredSessions.count == 0) {
        session = [[Session alloc] initWithRemoteJid:Jid];
        [self.sessions addObject:session];
    }
    else{
        session = filteredSessions[0];
    }
    session.remoteJid = Jid;
    return session;
}



- (BOOL) isValid{
    return [[self.Jid bare] isValidJid] && [self.password isValidPassword];
}


@end
