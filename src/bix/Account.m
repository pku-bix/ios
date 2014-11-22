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

-(id)initWithUsername:(NSString *)username{
    self = [super init];
    if(self){
        self.username = username;
        self.presence = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [self initWithUsername: (NSString*)[coder decodeObjectForKey:@"username"]];
    
    if (self) {
        self.nickname = [coder decodeObjectForKey:@"nickname"];
        self.signature = [coder decodeObjectForKey:@"signature"];
        self.wechatID = [coder decodeObjectForKey:@"wechatID"];
        self.teslaType = [coder decodeObjectForKey:@"teslaType"];
        self.presence = NO;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.nickname forKey:@"nickname"];
    [coder encodeObject:self.signature forKey:@"signature"];
    [coder encodeObject:self.wechatID forKey:@"wechatID"];
    [coder encodeObject:self.teslaType forKey:@"teslaType"];
}

- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // encoding
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey: [@"account_" stringByAppendingString: self.username]];
    
    // flush
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (Account*) loadByUsername: (NSString*)username{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:
                    [@"account_" stringByAppendingString: username]];
    return data == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData: data];
}

@end
