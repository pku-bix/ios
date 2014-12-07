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
#import "bixAPIProvider.h"
#import "bixFormBuild.h"


@interface bixLocalAccount()

// 获得上次登录的本地用户
+ (NSString*) restoreUsername;

//push的body类型:图片或者文字或者图片+文字;
@property (nonatomic)int bodyType;

-(id) initWithUsername:(NSString *)username Password: password;
@end


@implementation bixLocalAccount
{
    RequestInfoFromServer *request;

}

static bixLocalAccount *instance = nil;

-(void)pushProperties:(Properties)properties
{
    self.bodyType = properties;
    [bixAPIProvider Push:self];
}

#pragma mark bixRemoteModelDataSource

-(NSString*)modelPath
{
    return [NSString stringWithFormat: @"/api/user/%@",self.username];
}

-(NSData*)modelBody
{
    bixFormBuild *formBuild = [[bixFormBuild alloc]init];
    if (self.bodyType & avatar) {
        [formBuild addPicture:@"avatar" andImage:self.avatar.image];
    }
    
    if(self.bodyType & nickname){
        [formBuild addText:@"nickname" andText:self.nickname];
    }
    
    if (self.bodyType & signature)
    {
        [formBuild addText:@"signature" andText:self.signature];
    }
    
    if (self.bodyType & wechat_id) {
        [formBuild addText:@"wechat_id" andText:self.wechatID];
    }
    
    if (self.bodyType & teslaModel) {
        [formBuild addText:@"tesla_model" andText:self.teslaType];
    }
    
    return [formBuild closeForm];
}

#pragma mark bixRemoteModelDelegate
-(void)succeedWithStatus:(NSInteger)code
{
    NSLog(@"push成功，httpStatus: %d", code);
    [self save];
}

// singleton instance
+(bixLocalAccount*)instance{
    return instance;
}

// restore from file
+(bixLocalAccount*)restore{
    NSString* username = [bixLocalAccount restoreUsername];
    if (username==nil || !username.isValidUsername) {
        return nil;
    }
    return instance = [bixLocalAccount loadByUsername: username];
}

+(bixLocalAccount*)loadOrCreate: (NSString*)username Password: (NSString*)password{
    // load
    [bixLocalAccount loadByUsername:username];
    
    // create
    if (instance==nil) {
        instance = [[bixLocalAccount alloc] initWithUsername:username Password:password];
    }
    
    return instance;
}

+(void)save{
    if (instance!=nil && instance.presence) {
        [instance save];
    }
}


- (id) init{
    self = [super init];
    return self;
}

-(id) initWithUsername:(NSString *)username Password: password{
    self = [super initWithUsername:username];
    if(self){
        self.password = password;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    if (self) {
        _password    = [coder decodeObjectForKey: @"password"];
        _autoLogin   = [coder decodeBoolForKey:   @"auto_login"];
        _deviceToken = [coder decodeObjectForKey: @"device_token"];
        self.avatarImage = [coder decodeObjectForKey:@"avatarImage"];
    }

    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder: coder];
    [coder encodeObject:self.password forKey:@"password"];
    [coder encodeBool:self.autoLogin forKey:@"auto_login"];
    [coder encodeObject:self.deviceToken forKey:@"device_token"];
    //序列化本地头像
    [coder encodeObject:self.avatar forKey:@"avatar"];
    
    [coder encodeObject:self.avatarImage forKey:@"avatarImage"];
}


- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey: [@"local_account_" stringByAppendingString: self.username]];
    
    [defaults synchronize]; // flush
}

+(id)loadByUsername: (NSString*)username{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:
                    [@"local_account_" stringByAppendingString: username]];
    
    bixLocalAccount* ac = (data == nil) ? nil : [NSKeyedUnarchiver unarchiveObjectWithData: data];
    return instance = (ac.isValid ? ac : nil);
}

- (void) saveForRestore{
    [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"restore_username"];
}

+ (NSString*) restoreUsername{
    return [[NSUserDefaults standardUserDefaults] stringForKey: @"restore_username"];
}

- (void) setDeviceToken:(NSData *)deviceToken{
    _deviceToken = deviceToken;
    NSLog(@"发送deviceToken...");
    request = [[RequestInfoFromServer alloc]init];
    
    [request sendAsynchronousPostDeviceToken:_deviceToken];
    
}

// propperties
- (bool) isValid{
    return self.username.isValidUsername && [self.password isValidPassword];
}

- (NSString*)description{
    return [NSString stringWithFormat:@"bixLocalAccount: %@", self.username];
}

@end
