//
//  NSDate+Wrapper.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "NSDate+Wrapper.h"

@implementation NSDate(Wrapper)

+(NSString *)getCurrentTime{
    
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [dateFormatter stringFromDate:nowUTC];
    
}

@end
