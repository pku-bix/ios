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


@interface bixLocalAccount : Account


@property (nonatomic) NSString* password;
@property (nonatomic) bool autoLogin;
// used for remote push service
@property (nonatomic) NSData* deviceToken;
// register validation
@property (readonly) bool isValid;
//用户本地头像
@property (nonatomic) UIImage* avatar;


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
