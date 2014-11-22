//
//  NSString+Account.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Constants.h"
#import "XMPPFramework.h"

@implementation NSString(Account)

-(NSString*) toJidStr{
    //addr
    if ([self rangeOfString:@"/"].location != NSNotFound ){
        NSString* bareJid = (NSString*)[[self componentsSeparatedByString:@"/"] objectAtIndex:0];
        return bareJid;
    }
    //Jid
    if ([self rangeOfString:@"@"].location != NSNotFound ){
        return self;
    }
    
    //username
    NSString* username = [self
                          stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* bareJid = [username stringByAppendingFormat:@"@%@",XMPP_SERVER_DOMAIN];
    return bareJid;
}

-(XMPPJID*) toJid{
    return [XMPPJID jidWithString: self.toJidStr];
}

-(NSString*)toUsername{
    //username
    if ([self rangeOfString:@"@"].location == NSNotFound )
        return self;
    
    //Jid/addr
    return [[self componentsSeparatedByString:@"@"] objectAtIndex:0];
}


-(BOOL)isValidUsername{
    
    NSString *usernameRegex = @"[A-Za-z][A-Z0-9a-z]{1,31}";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    
    return [usernameTest evaluateWithObject:self];
    
}

-(BOOL)isValidPassword{
    
    NSString *passwordRegex = @"[A-Z0-9a-z_]{5,15}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    return [passwordTest evaluateWithObject:self];
    
}

-(BOOL)isValidEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

-(BOOL)isValidJidStr{
    NSString *jidRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+";
    NSPredicate *jidTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", jidRegex];
    
    return [jidTest evaluateWithObject:self];
}
@end
