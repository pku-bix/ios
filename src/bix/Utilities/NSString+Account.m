//
//  NSString+Account.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Constants.h"

@implementation NSString(Account)

-(NSString*)toJid{
    return [self stringByAppendingFormat: @"@%@", SERVER_NAME];
}

-(NSString*)toUsername{
    if ([self rangeOfString:@"@"].location == NSNotFound ) {
        return self;
    }
    return [[self componentsSeparatedByString:@"@"] objectAtIndex:0];
}

-(BOOL)isValidUsername{
    
    NSString *usernameRegex = @"[A-Z0-9a-z._%+-]{1,20}";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    
    return [usernameTest evaluateWithObject:self];
    
}

-(BOOL)isValidPassword{
    
    NSString *passwordRegex = @"[A-Z0-9a-z_]{5,15}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    return [passwordTest evaluateWithObject:self];
    
}

-(BOOL)isValidateEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

@end
