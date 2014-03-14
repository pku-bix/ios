//
//  XMPPMessage+Wrapper.m
//  bix
//
//  Created by harttle on 14-3-14.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "XMPPMessage+Wrapper.h"
#import "AppDelegate.h"

@implementation XMPPMessage (Wrapper)


// time property
NSDate* _time;

-(NSDate*)time{
    return _time;
}

-(void)setTime:(NSDate*) time{
    _time = time;
}


// isMine property
-(BOOL) isMine{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    return [appdelegate.account.Jid.bare isEqualToString: self.from.bare];
}


// constructor
-(id)initWithBody:(NSString *)body From:(XMPPJID*)from To:(XMPPJID*)to{
    
    self = [self initWithType:@"chat" to:to];
    if(self){
        [self addBody:body];
        [self addAttributeWithName:@"from" stringValue: [from bare]];
        self.time = [NSDate date];
    }
    return self;
}


@end
