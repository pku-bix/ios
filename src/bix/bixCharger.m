//
//  bixCharger.m
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixCharger.h"

@implementation bixCharger


#pragma mark RemoteModel DataSource

// 在API服务器模型的路径，eg：charger/ef131ab3f34133ab
-(NSString*) modelPath
{
    return [NSString stringWithFormat:@"charger/%@", self.modelId];
}

// PUSH请求的request body
-(NSData*) modelBody{
    return NULL;
}


-(void) SucceedWithStatus: (NSInteger) code andJSONResult: (NSObject*) result{
    id obj = (NSDictionary*)result;
    self.parkingnum = [[obj objectForKey:@"parkingnum"] intValue];
}

@end
