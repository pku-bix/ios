//
//  Message.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface Message : NSObject

@property (nonatomic) int number;
@property (nonatomic,retain) NSString* text;
@property (nonatomic) BOOL isMine;
@property (nonatomic,retain) NSDate* time;

@end
