//
//  Account.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic,copy) NSString* username;
@property (nonatomic,copy) NSString* password;
@property (nonatomic) int selectedTabIndex;
@property (nonatomic) BOOL autoLogin;
@property (nonatomic) NSString* Jid;
@property (nonatomic) BOOL presence;

- (id) init;
- (id) initWithJid: (NSString*)Jid;
- (id) initWithUsername:(NSString*)username Password:(NSString*)password;


- (void) save;
- (BOOL) isValid;

+ (Account*) loadDefault;

@end
