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


- (bool) post{
    // sync = [[bixRemoteSync alloc] init];
    // sync.model = self;
    // [sync push];
    return true;
}

-(NSString*) modelPath{
    return @"chargers/";
}

// TODO: 借助用HTTP层，从 user 动态获取以下属性

-(NSURL*) avatarUrl{
    return self.sender.avatarUrl;
}

-(NSString*) nickname{
    return self.sender.nickname;
}

//传进去的sender要设置好avatarUrl和nickname两个属性字段;
-(id) initWithSender:(Account *)sender{
    self = [super init];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseMoment:) name:@"sendNewMomentText" object:nil];
    
    if(self){
        _sender = sender;
//        _imgUrls = [NSMutableArray new];
        _replies = [NSMutableArray new];
        _uiImageData = [NSMutableArray arrayWithCapacity:2];
        
        // TODO: 使用HTTP层代替以下的静态测试数据
//        [_imgUrls addObject:sender.avatarUrl];
//        [_imgUrls addObject: @"http://image.tianjimedia.com/uploadImages/2013/231/Y86BKHJ2E2UH.jpg"];
//        [_imgUrls addObject: @"http://image.tianjimedia.com/uploadImages/2013/231/Y86BKHJ2E2UH.jpg"];
//        [_imgUrls addObject: @"http://image.tianjimedia.com/uploadImages/2013/231/Y86BKHJ2E2UH.jpg"];
//        
        [_replies addObject:[[bixMomentReplyItem alloc] initWithSender:sender andReplyText:@"成功显示"]];
        [_replies addObject:[[bixMomentReplyItem alloc] initWithSender:sender andReplyText:@"棒啊"]];
    }
//    [self.momentText addObject: @"这是一个分享的内容，这是一个分享的内容，这是一个分享的内容。"];
    return self;
}

-(void)parseMoment:(NSNotification*)notification
{
    self.textContent = notification.object;
    //NSLog(@"parseMoment in bixMomentDataItem.h is %@", momentPassage);
}

-(NSString *)description{
    return [NSString stringWithFormat:@"nickname:%@\navatarUrl:%@\npassage:%@\npictureUrls:%@\nreplies:%@",
     self.nickname, self.avatarUrl, self.textContent, self.imgUrls, self.replies];
}

@end
