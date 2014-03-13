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

@synthesize Jid;

-(NSString*) Jid{
    return [self.username toJid];
}

-(void) setUsername:(NSString *)username{
    //trimming
    _username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(id) init {
    return [self initWithUsername:nil Password:nil];
}

-(id) initWithJid:(NSString *)_Jid{
    return [self initWithUsername:[_Jid toUsername] Password:@""];
}

-(id) initWithUsername: (NSString*) username Password:(NSString*) password{
    return [self initWithUsername:username Password:password AutoLogin:TRUE];
}

-(id) initWithUsername: (NSString*) username Password:(NSString*) password AutoLogin:(BOOL) autoLogin{
    self = [super init];
    if(self)   {
        self.username = username;
        self.password = password;
        self.autoLogin = autoLogin;
    }
    return self;
}

- (BOOL) isValid{
    return [self.password isValidPassword] && [self.username isValidUsername];
}

- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.password forKey: [self.username stringByAppendingString: PASSWORD_SUFFIX]];
    [defaults setBool:self.autoLogin forKey: [self.username stringByAppendingString: AUTOLOGIN_SUFFIX]];
    [defaults setInteger:self.selectedTabIndex forKey:[self.username stringByAppendingString:DEFAULTTAB_SUFFIX]];
}

+ (Account*) loadDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* username = [defaults stringForKey: LAST_USERID];
    
    if (username == nil) {
        return nil;
    }
    
    NSString* password = [defaults stringForKey: [username stringByAppendingString: PASSWORD_SUFFIX]];
    BOOL autoLogin = [defaults boolForKey: [username stringByAppendingString: AUTOLOGIN_SUFFIX]];
    
    Account* account = [[Account alloc] initWithUsername: username Password: password AutoLogin:autoLogin];
    account.selectedTabIndex = [defaults integerForKey:[username stringByAppendingString:DEFAULTTAB_SUFFIX]];
    return account;
}

@end
