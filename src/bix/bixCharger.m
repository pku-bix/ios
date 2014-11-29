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

    return [NSString stringWithFormat:@"/api/charger/%@", self.modelId];
}

// PUSH请求的request body
-(NSData*) modelBody{
    return NULL;
}


-(void) SucceedWithStatus: (NSInteger) code andJSONResult: (NSObject*) result{
    id obj = (NSDictionary*)result;
    @try {
        self.parkingnum = [[obj objectForKey:@"parkingnum"] intValue];
        self.address = [obj objectForKey:@"detailedaddress"];
        self.latitude = [[obj objectForKey:@"latitude" ] doubleValue];
        self.longitude = [[obj objectForKey:@"longitude"]doubleValue];
        self.comment = [obj objectForKey:@"comment"] ;
                
    }
    @catch (NSException *exception) {
        NSLog(@"解析错误，exception:%@", exception);
    }
    @finally {
        
    }
}

@end
