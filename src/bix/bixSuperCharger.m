//
//  bixSuperCharger.m
//  bix
//
//  Created by harttle on 11/25/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixSuperCharger.h"

@implementation bixSuperCharger

+(NSString*) description{
    return @"超级充电桩";
}


#pragma mark RemoteModel Delegate

// 数据响应成功，填充pull下来的字段
-(void) populateWithJSON:(NSObject *)result{
    [super populateWithJSON:result];
    
    @try{
        self.hours = [result valueForKey:@"hours"];
        self.homepage = [result valueForKey:@"homepage"];
    }
    @catch(NSException* e){
#ifdef DEBUG
        NSLog(@"parse super charger error:%@", e);
#endif
    }
    [super modelUpdateComplete];
}

@end
