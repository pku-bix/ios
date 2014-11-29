//
//  bixSuperCharger.m
//  bix
//
//  Created by harttle on 11/25/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixSuperCharger.h"

@implementation bixSuperCharger


#pragma mark RemoteModel Delegate

// 数据响应成功，填充pull下来的字段
-(void) SucceedWithStatus: (NSInteger) code andJSONResult: (NSObject*) result{
    //id obj = (NSDictionary*)result;
    [super SucceedWithStatus:code andJSONResult:result];
    
    [self.observer modelUpdated:self];
     self.cb(self);

    // todo 子类特有的
    [self.observer modelUpdated: self];
}

@end
