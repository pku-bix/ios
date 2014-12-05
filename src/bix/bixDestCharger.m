//
//  bixDestCharger.m
//  bix
//
//  Created by harttle on 11/25/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixDestCharger.h"

@implementation bixDestCharger

+(NSString*) description{
    return @"目的地充电桩";
}


#pragma mark RemoteModel Delegate

// 数据响应成功，填充pull下来的字段
-(void) populateWithJSON:(NSObject *)result{
    [super populateWithJSON:result];
    
    
    [super modelUpdateComplete];
}

@end
