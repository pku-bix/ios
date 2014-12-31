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
#import "bixImageProxy.h"

@implementation Account

-(NSString*)displayName{
    if (self.nickname && self.nickname.length) {
        return self.nickname;
    }
    return self.username;
}

-(NSString*)displaySignature{
    if (self.signature && self.signature.length) {
        return self.signature;
    }
    return @"这个人很懒，还没有描述。";
}

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
        self.avatar = [coder decodeObjectForKey:@"avatar"];
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
    [coder encodeObject:self.avatar forKey:@"avatar"];
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

-(NSString*) modelPath{
    return [NSString stringWithFormat: @"/api/user/%@", self.username];
}

-(void)populateWithJSON:(NSObject *)result{
    @try {
        self.nickname = [result valueForKey:@"nickname"];


        self.signature = [result valueForKey:@"signature"];
        
        self.avatar = [[bixImageProxy alloc]
                       initWithUrl:[result valueForKey:@"avatar"]
                       andThumbnail:[result valueForKey:@"avatar_thumbnail"]];
    }
    @catch (NSException *exception) {
#ifdef DEBUG
        NSLog(@"parse account error:%@", exception);
#endif
    }
    [super modelUpdateComplete];
}


@end
