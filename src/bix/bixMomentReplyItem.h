//
//  bixMomentReplyItem.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface bixMomentReplyItem : NSObject

@property (readonly,nonatomic) NSURL* avatarUrl;  //评论者的头像
@property (readonly) NSString* nickname;          //评论者的用户名
@property (readonly) NSString* text;              //评论者的评论文本数据

-(id)initWithSender:(Account*) sender;
-(id)initWithSender:(Account*) sender andReplyText:(NSString*) text;

@end
