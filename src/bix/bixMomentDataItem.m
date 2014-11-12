//
//  bixMomentDataItem.m
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixMomentDataItem.h"
#import "Account.h"
#import "bixMomentReplyItem.h"

@interface bixMomentDataItem()

@property Account* sender;

@end



@implementation bixMomentDataItem
{
//    int test5;
}

//int uio;

// TODO: 借助用HTTP层，从 user 动态获取以下属性

-(NSURL*) avatarUrl{
//    test = 5;
//    test5 = 8;
//    uio = 9;
    return self.sender.avatarUrl;
}

-(NSString*) nickname{
    return self.sender.nickname;
}

-(NSString*) passage{
    return @"这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容，这是一个分享的内容。";
}


-(id) initWithSender:(Account *)sender{
    self = [super init];
    if(self){
        _sender = sender;
        _pictureUrls = [NSMutableArray new];
        _replies = [NSMutableArray new];
        
        // TODO: 使用HTTP层代替以下的静态测试数据
        [_pictureUrls addObject:sender.avatarUrl];
        [_pictureUrls addObject: @"http://image.tianjimedia.com/uploadImages/2013/231/Y86BKHJ2E2UH.jpg"];
        [_pictureUrls addObject: @"http://image.tianjimedia.com/uploadImages/2013/231/Y86BKHJ2E2UH.jpg"];
        [_pictureUrls addObject: @"http://image.tianjimedia.com/uploadImages/2013/231/Y86BKHJ2E2UH.jpg"];
        
        [_replies addObject:[[bixMomentReplyItem alloc] initWithSender:sender andReplyText:@"呵呵呵"]];
        [_replies addObject:[[bixMomentReplyItem alloc] initWithSender:sender andReplyText:@"哈哈哈"]];
    }
    
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"nickname:%@\navatarUrl:%@\npassage:%@\npictureUrls:%@\nreplies:%@",
     self.nickname, self.avatarUrl, self.passage, self.pictureUrls, self.replies];
}

@end
