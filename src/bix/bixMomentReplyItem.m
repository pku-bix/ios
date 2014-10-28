//
//  bixMomentReplyItem.m
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixMomentReplyItem.h"
#import "Account.h"

@interface bixMomentReplyItem()

@property Account* sender;

@end


@implementation bixMomentReplyItem

-(id)initWithSender:(Account*) sender{
    return [self initWithSender:sender andReplyText:@""];
}

-(id)initWithSender:(Account*) sender andReplyText:(NSString*) text{
    self = [super init];
    
    if(self){
        _sender = sender;
        _text = text;
    }
    return self;
}

-(NSString*) nickname{
    return self.sender.nickname;
}
-(NSURL*) avatarUrl{
    return self.sender.avatarUrl;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@ replies: %@ with avatarUrl:%@",self.nickname, self.text, self.avatarUrl];
}

@end
