//
//  Account.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic,copy) NSString* address;
@property (nonatomic,copy) NSString* password;

@property (nonatomic) NSString* username;
@property (nonatomic) NSString* servername;
@property (nonatomic) NSString* devicename;
@property (nonatomic) NSString* Jid;


@property (nonatomic) int selectedTabIndex;
@property (nonatomic) BOOL autoLogin;
@property (nonatomic) BOOL presence;


-(id) init;
-(id) initWithAddr: (NSString*)addr;
-(id) initWithAddr: (NSString*) addr Password:(NSString*) password;


- (void) save;
- (BOOL) isValid;

+ (Account*) loadDefault;

@end
