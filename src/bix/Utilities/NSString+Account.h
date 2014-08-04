//
//  NSString+Account.h
//  Bix
//
//  Created by harttle on 14-3-10.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Account)

-(BOOL)isValidUsername;
-(BOOL)isValidEmail;
-(BOOL)isValidPassword;
-(BOOL)isValidJid;


// Jid/addr
-(NSString*)toJid;

// username/Jid/addr
-(NSString*)toUsername;

/*
 // username
-(NSString*)toJid:(NSString*)servername;


// Jid/addr
-(NSString*)toAddr:(NSString*)devicename;
// username
-(NSString*)toAddr:(NSString*)servername Devicename:(NSString*)devicename;

// Jid/addr
-(NSString*)toServername;

// addr
-(NSString*)toDevicename;
 */
@end
