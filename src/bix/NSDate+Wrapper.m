//
//  NSDate+Wrapper.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "NSDate+Wrapper.h"

@implementation NSDate(Wrapper)

+(NSString *)getCurrentTimeString{
    return [[NSDate date] toFriendlyString];
}


-(NSString*) toFriendlyString{
    
    unsigned unitFlags =NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *componentsMsg = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
    NSDateComponents *componentsNow = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSTimeInterval timeInterval = [self timeIntervalSinceNow];
    NSString* szDate = @"";
    
    // in 1 day
    if(timeInterval > -24*3600){
        
        // in 1 normal day
        if(componentsNow.day > componentsMsg.day ) szDate  = @"昨天 ";
        
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    // in 1 normal week
    else if(timeInterval > -7*24*3600 && componentsNow.weekday != componentsMsg.weekday){
       
        szDate = [NSDate getWeekdayWithNumber:componentsMsg.weekday];
        [dateFormatter setDateFormat:@" HH:mm"];
    }
    else{
        // 1 week before
        [dateFormatter setDateFormat:@"yyyy-M-d HH:mm"];
    }
    return [szDate stringByAppendingString:[dateFormatter stringFromDate:self]];
}


+(NSString *)getWeekdayWithNumber:(int)number{
    switch (number) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}

@end
