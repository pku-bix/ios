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
    }
    return self;
}

- (BOOL) isValid{
    return [[self.Jid bare] isValidJid] && [self.password isValidPassword];
}

- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.password forKey: [[self.Jid bare] stringByAppendingString: PASSWORD_SUFFIX]];
    [defaults setBool:self.autoLogin forKey: [[self.Jid bare] stringByAppendingString: AUTOLOGIN_SUFFIX]];
    [defaults setInteger:self.selectedTabIndex forKey:[[self.Jid bare] stringByAppendingString:DEFAULTTAB_SUFFIX]];
}

+ (Account*) loadDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* bareJid = [defaults stringForKey: LASTUSER_BAREJID];
    
    if (bareJid == nil) {
        return nil;
    }
    
    NSString* password = [defaults stringForKey: [bareJid stringByAppendingString: PASSWORD_SUFFIX]];
    
    Account* account = [[Account alloc] initWithJid:[XMPPJID jidWithString: bareJid]
                                            Password: password];
    account.autoLogin = [defaults boolForKey:
                         [bareJid stringByAppendingString: AUTOLOGIN_SUFFIX]];
    account.selectedTabIndex = [defaults integerForKey:
                                [bareJid stringByAppendingString:DEFAULTTAB_SUFFIX]];
    return account;
}

@end
