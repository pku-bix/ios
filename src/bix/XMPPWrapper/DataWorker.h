//
//  DataWorker.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

@interface DataWorker : NSObject 

@property (nonatomic, retain) NSMapTable* contacts;
@property (nonatomic, retain) NSMapTable* sessions;

-(id)init;
    
@end
