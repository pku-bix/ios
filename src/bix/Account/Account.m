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


// getter
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
}

// constructor

-(id) init {
    return [self initWithAddr:@""];
}

-(id) initWithAddr: (NSString*)addr{
    return [self initWithAddr:addr Password:@""];
}

-(id) initWithAddr: (NSString*) addr Password:(NSString*) password{
    self = [super init];
    if(self)   {
        self.address = addr;
        self.password = password;
    }
    return self;
}

- (BOOL) isValid{
    return [self.address isValidAddress] && [self.password isValidPassword];
}

- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.password forKey: [self.address stringByAppendingString: PASSWORD_SUFFIX]];
    [defaults setBool:self.autoLogin forKey: [self.address stringByAppendingString: AUTOLOGIN_SUFFIX]];
    [defaults setInteger:self.selectedTabIndex forKey:[self.address stringByAppendingString:DEFAULTTAB_SUFFIX]];
}

+ (Account*) loadDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* address = [defaults stringForKey: LASTUSER_ADDRESS];
    
    if (address == nil) {
        return nil;
    }
    
    NSString* password = [defaults stringForKey: [address stringByAppendingString: PASSWORD_SUFFIX]];
    
    Account* account = [[Account alloc] initWithAddr: address
                                            Password: password];
    account.autoLogin = [defaults boolForKey:
                         [address stringByAppendingString: AUTOLOGIN_SUFFIX]];
    account.selectedTabIndex = [defaults integerForKey:
                                [address stringByAppendingString:DEFAULTTAB_SUFFIX]];
    return account;
}

@end
