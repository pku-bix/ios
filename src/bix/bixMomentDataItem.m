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
#import "bixFormBuilder.h"
#import "bixLocalAccount.h"
#import "bixImageProxy.h"
#import "bixChatProvider.h"

@interface bixMomentDataItem()

@end

@implementation bixMomentDataItem




// TODO: 借助用HTTP层，从 user 动态获取以下属性

-(NSString*) nickname{
    return self.sender.nickname;
}

//初始化函数中需要对数组进行内存申请
-(id)init
{
    self = [super init];
        if(self){
            _replies = [NSMutableArray new];
            self.imageProxyArray = [NSMutableArray new];
        }
    return self;
}

-(id) initWithSender:(Account *)sender{
    self = [self init];
    
    if (self) {
        _sender = sender;
//        [_replies addObject:[[bixMomentReplyItem alloc] initWithSender:sender andReplyText:@"成功显示"]];
//        [_replies addObject:[[bixMomentReplyItem alloc] initWithSender:sender andReplyText:@"棒啊"]];
    }
    return self;
}

-(NSString *)modelPath
{
    return @"/api/posts";
}

-(NSData *)modelBody
{
    bixLocalAccount *localAccount = [bixLocalAccount instance];
    
    bixFormBuilder *formBuild = [[bixFormBuilder alloc]init];
    //添加用户名字段
    [formBuild addText:@"author" andText:localAccount.username];
    //添加分享的文字字段
    [formBuild addText:@"content" andText:self.textContent];
    
    //添加分享的图片
    for (bixImageProxy*p in self.imageProxyArray) {
        NSLog(@"分享的图片数据");
        
        [formBuild addPicture:@"images" andImage:p.image];
    }
    
    return [formBuild closeForm];
}

-(void)push
{
    [bixAPIProvider Push:self];
}

-(void)populateWithJSON:(NSObject *)result{
    [super populateWithJSON:result];
    @try{
        NSDictionary* dict = (NSDictionary*) result;
        self.textContent = [dict objectForKey:@"content"];

        // images sended

//        for (id obj in self.imageProxyArray) {
//            bixImageProxy *imageProxy = [[bixImageProxy alloc]initWithImage:obj];
//            imageProxy.image
//        }

//        if ([(bixImageProxy*)self.imageProxyArray[0] image] == nil) {
//            [self.imageProxyArray removeAllObjects];
//        }
//            [self.imageProxyArray removeAllObjects];


//        if (tempImageProxy.image == nil) {
//           [self.imageProxyArray removeAllObjects];
            NSMutableArray *imagesURL = [dict objectForKey:@"images"];
            NSMutableArray *thumbnailImagesURL = [dict objectForKey:@"images_thumbnail"];
            for(int i = 0; i < imagesURL.count; i++)
            {
                NSLog(@"bixMomentDataItem.m imagesURL.count is %d", imagesURL.count);
                bixImageProxy *imageProxy = [[bixImageProxy alloc]initWithUrl:imagesURL[i] andThumbnail:thumbnailImagesURL[i]];
                [self.imageProxyArray addObject:imageProxy];
            }
            bixImageProxy *tempImageProxy = [self.imageProxyArray objectAtIndex:0];
            if (tempImageProxy.image != nil)
            {
                for (int j = 0; j < imagesURL.count; j++) {
                    [self.imageProxyArray removeLastObject];
                }
            }
////        }
//        if (tempImageProxy.image != nil) {
//            for (int j = 0; j < imagesURL.count; j++) {
//                [self.imageProxyArray removeLastObject];
//            }
////
//        }
        // sender object
        NSObject* author = [result valueForKey:@"author"];
        self.sender = [[bixChatProvider defaultChatProvider]
                       getConcactByUsername: [author valueForKey:@"username"]];
        [self.sender populateWithJSON:author];     
        

    }
    @catch(NSException* e){
        NSLog(@"parse moment item error, %@", e);
    }
    [super modelUpdateComplete];
}

-(void)connectionFailedWithError:(NSError *)err
{
    
}

-(NSString *)description{
    return [NSString stringWithFormat:@"nickname:%@\navatarUrl:%@\npassage:%@\nreplies:%@",
     self.nickname, self.sender.avatar, self.textContent, self.replies];
}

@end
