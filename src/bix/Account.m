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
//    self.Jid.username;
//    self.Jid.user
}
-(NSString*)username
{
//    NSLog(@"user is %@", self.Jid.user);
    return self.Jid.user;
    
}

-(id) initWithJid: (XMPPJID*) jid{
    self = [self init];
    if(self){
        self.Jid = jid;
        self.presence = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [self initWithJid:[XMPPJID jidWithString:
                              (NSString*)[coder decodeObjectForKey:KEY_BAREJID]]];
    
    if (self) {
            //设置界面 ==> 个人信息页面， 姓名字段 
        self.name = [coder decodeObjectForKey:@"name"];
        self.signature = [coder decodeObjectForKey:@"signature"];
        self.loginID = [coder decodeObjectForKey:@"loginID"];
        self.wechatID = [coder decodeObjectForKey:@"wechatID"];
        self.teslaType = [coder decodeObjectForKey:@"teslaType"];
        //个人头像
//        self.getHeadImage = [coder decodeObjectForKey:@"getHeadImage"];

        self.presence = NO;
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
    [defaults setObject:data forKey: [@"account" stringByAppendingString: self.Jid.bare]];
    
    // flush
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.Jid.bare forKey:KEY_BAREJID];
    //设置界面 ==> 个人信息页面， 姓名字段
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.signature forKey:@"signature"];
    [coder encodeObject:self.loginID forKey:@"loginID"];
    [coder encodeObject:self.wechatID forKey:@"wechatID"];
    [coder encodeObject:self.teslaType forKey:@"teslaType"];
    //个人头像
//    [coder encodeObject:self.getHeadImage forKey:@"getHeadImage"];
}

// remote account also need this, with cache considered
+ (Account*) load: (NSString*)bareJid{
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:
                    [@"account" stringByAppendingString: bareJid]];
    return data == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData: data];
}

@end
