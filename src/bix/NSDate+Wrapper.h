//
//  NSDate+Wrapper.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Wrapper)

+(NSString *)getWeekdayWithNumber:(int)number;
+(NSString *)getCurrentTimeString;

-(NSString*) toFriendlyString;
    
@end
