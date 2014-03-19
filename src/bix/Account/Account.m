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

@implementation Account


/*/ getter
@synthesize username;
-(NSString*) username{
    return [self.address toUsername];
}
@synthesize servername;
-(NSString*) servername{
    return [self.address toServername];
}
@synthesize devicename;
-(NSString*) devicename{
    return [self.address toDevicename];
}
@synthesize Jid;
-(NSString*) Jid{
    return [self.address toJid];
}*/

@synthesize bareJid;
-(NSString*) bareJid{
    return [self.Jid bare];
}

// constructor

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
        
        // pre-init, just in case
        self.contacts = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [self initWithJid:[XMPPJID jidWithString:
                              (NSString*)[coder decodeObjectForKey:KEY_JID]]
                    Password:(NSString*)[coder decodeObjectForKey:KEY_PASSWORD]];
    if (self) {
        self.autoLogin = [coder decodeBoolForKey:KEY_AUTOLOGIN];
        //self.selectedTabIndex = [coder decodeIntForKey:KEY_ACTIVE_TABINDEX];
        self.contacts = [coder decodeObjectForKey:KEY_CONTACT_LIST];
        if (self.contacts == nil) {
            self.contacts = [NSMutableArray array];
        }
    }
    return self;
}

- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // encode self
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:self.Jid.bare];
    
    // flush to mm
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.Jid.bare forKey:KEY_JID];
    [coder encodeObject:self.password forKey:KEY_PASSWORD];
    [coder encodeBool:self.autoLogin forKey:KEY_AUTOLOGIN];
    //[coder encodeInt: self.selectedTabIndex forKey:KEY_ACTIVE_TABINDEX];
    [coder encodeObject:self.contacts forKey:KEY_CONTACT_LIST];
}

+ (Account*) loadDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* bareJid = [defaults stringForKey: KEY_ACTIVE_JID];
    
    if (bareJid == nil) {
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:bareJid]];
}

//query contact, add when needed
-(Account*)updateConcact: (XMPPJID*)Jid{
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


- (BOOL) isValid{
    return [[self.Jid bare] isValidJid] && [self.password isValidPassword];
}


@end
