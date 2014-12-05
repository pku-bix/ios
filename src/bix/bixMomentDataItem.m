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
#import "bixAPIProvider.h"
#import "bixFormBuild.h"
#import "bixLocalAccount.h"

@interface bixMomentDataItem()

@property Account* sender;

@end

@implementation bixMomentDataItem




// TODO: 借助用HTTP层，从 user 动态获取以下属性

-(NSURL*) avatarUrl{
    return [NSURL URLWithString: self.sender.avatar];
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
        _imgUrls = [NSMutableArray arrayWithCapacity:10];
        _replies = [NSMutableArray new];
        _uiImageData = [NSMutableArray arrayWithCapacity:2];   //用户发送的图片数据;
        
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

-(NSString *)modelPath
{
    return @"/api/posts";
}

-(NSData *)modelBody
{
    bixLocalAccount *localAccount = [bixLocalAccount instance];
    
    bixFormBuild *formBuild = [[bixFormBuild alloc]init];
    //添加用户名字段
    [formBuild addText:@"author" andText:localAccount.username];
    //添加分享的文字字段
    [formBuild addText:@"content" andText:self.textContent];
    
    //添加分享的图片
    for (id image in self.uiImageData) {
        NSLog(@"分享的图片数据");
        [formBuild addPicture:@"images" andImage:image];
    }
    
    return [formBuild closeForm];
}


-(void)push
{
    [bixAPIProvider Push:self];
}

-(void)populateWithJSON:(NSObject *)result{
    @try{
        NSDictionary* dict = (NSDictionary*) result;
        self.textContent = [dict objectForKey:@"content"];
        // TODO: 填充字段
    }
    @catch(NSException* e){
        NSLog(@"parse moment item error, %@", e);
    }
}

-(NSString *)description{
    return [NSString stringWithFormat:@"nickname:%@\navatarUrl:%@\npassage:%@\npictureUrls:%@\nreplies:%@",
     self.nickname, self.sender.avatar, self.textContent, self.imgUrls, self.replies];
}

@end
