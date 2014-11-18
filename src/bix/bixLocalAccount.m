//
//  bixLocalAccount.m
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixLocalAccount.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "NSString+Account.h"
#import "RequestInfoFromServer.h"

@implementation bixLocalAccount
{
    RequestInfoFromServer *request;
}

- (id) init{
    self = [super init];
    return self;
}

-(id) initWithJid: (XMPPJID*) jid Password:(NSString*) password{
    self = [super initWithJid:jid];
    
    if(self)   {
        self.password = password;
    }
    return self;
}


-(id) initWithUsername:(NSString *)username Password:(NSString *)password{
    return [self initWithJid: [XMPPJID jidWithString: [username toJid]] Password:password];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        _password    = [coder decodeObjectForKey: KEY_PASSWORD];
        _autoLogin   = [coder decodeBoolForKey:   KEY_AUTOLOGIN];
        _deviceToken = [coder decodeObjectForKey: KEY_DEVICE_TOKEN];
        _avatar = [coder decodeObjectForKey:@"avatar"];
    }

    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder: coder];
    [coder encodeObject:self.password forKey:KEY_PASSWORD];
    [coder encodeBool:self.autoLogin forKey:KEY_AUTOLOGIN];
    [coder encodeObject:self.deviceToken forKey:KEY_DEVICE_TOKEN];
    //序列化本地头像
    [coder encodeObject:self.avatar forKey:@"avatar"];
}


- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey: [@"local_account" stringByAppendingString: self.Jid.bare]];
    
    [defaults synchronize]; // flush
}
+ (bixLocalAccount*) load: (NSString*)bareJid{
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:
                    [@"local_account" stringByAppendingString: bareJid]];
    return data == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData: data];
}


- (void) saveAsActiveUser{
    [[NSUserDefaults standardUserDefaults] setObject:self.bareJid forKey:KEY_ACTIVE_JID];
}

+ (NSString*) getActiveJid{
    return [[NSUserDefaults standardUserDefaults] stringForKey: KEY_ACTIVE_JID];
}

// TODO: @杜实现 在该方法中POST该Token至 /api/user/<username>
- (void) setDeviceToken:(NSData *)deviceToken{
    _deviceToken = deviceToken;
    
    request = [[RequestInfoFromServer alloc]init];
    
    [request sendAsynchronousPostDeviceToken:_deviceToken];
    
}

// propperties
- (bool) getIsValid{
    return [[self.Jid bare] isValidJid] && [self.password isValidPassword];
}

@end
