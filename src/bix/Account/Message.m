//
//  Message.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "Message.h"
#import "NSDate+Wrapper.h"

@implementation Message

-(id)initWithMessageText:(NSString*)msg isMine:(BOOL)isMine{
    self = [super init];
    if(self){
        self.text = msg;
        self.isMine = isMine;
        self.time = [NSDate date];
    }
    return self;
}

@end
