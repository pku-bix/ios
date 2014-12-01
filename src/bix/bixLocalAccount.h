//
//  bixLocalAccount.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//
// 本地用户。继承自 Account，该类中维护了只有本地用户才需要存储的信息，如xmpp实体、密码、完整的用户信息。
//

#import "Account.h"
#import "bixRemoteModelDelegate.h"
#import "bixRemoteModelDataSource.h"

@interface bixLocalAccount : Account<bixRemoteModelDelegate,bixRemoteModelDataSource>

typedef enum Properties: NSUInteger
{
    nickname = 1 << 0,     //1
    signature = 1 << 1,    //2
    wechat_id = 1 << 2,     //4
    teslaModel = 1 << 3,   //8
    avatar = 1 << 4        //16
}Properties;

//push用户属性到服务器;
-(void)pushProperties:(Properties)properties;

//用户的头像image数据; 用于post，不是用于展示,展示头像还是通过url;
@property (nonatomic) UIImage * avatarImage;

@property (nonatomic) NSString* password;
@property (nonatomic) bool autoLogin;
// used for remote push service
@property (nonatomic) NSData* deviceToken;
// register validation
@property (readonly) bool isValid;


//- (id) initWithUsername: (NSString*)username Password:(NSString*) password;
- (void) save;
- (void) saveForRestore;

// try save instance
+ (void)save;
// get the instance
+ (bixLocalAccount*) instance;

// 从文件载入用户
+(bixLocalAccount*)loadByUsername: (NSString*)username;
// restore from file
+(bixLocalAccount*)restore;
// always returns a valid account
+(bixLocalAccount*)loadOrCreate: (NSString*)username Password: (NSString*)password;

@end
