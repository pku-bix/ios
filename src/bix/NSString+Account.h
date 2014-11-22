//
//  NSString+Account.h
//  Bix
//
//  Created by harttle on 14-3-10.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface NSString (Account)

-(BOOL)isValidUsername;
-(BOOL)isValidEmail;
-(BOOL)isValidPassword;
-(BOOL)isValidJidStr;


-(NSString*) toJidStr;
-(XMPPJID*)toJid;
-(NSString*)toUsername;

@end
