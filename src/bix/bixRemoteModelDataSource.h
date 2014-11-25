//
//  bixRemoteModelDataSource.h
//  bix
//
//  Created by harttle on 11/25/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol bixRemoteModelDataSource <NSObject>


// 在API服务器模型的路径，eg：charger/ef131ab3f34133ab
-(NSString*) modelPath;


@optional

// PUSH请求的request body
-(NSData*) modelBody;


@end
