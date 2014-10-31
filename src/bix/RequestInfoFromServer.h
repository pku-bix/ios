//
//  RequestInfoFromServer.h
//  bix
//
//  Created by dsx on 14-10-8.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestInfoFromServer : NSObject<NSURLConnectionDataDelegate>
{
    int chargePileNumber;
    NSMutableArray *muArray, *detailInfoArray;
}

@property int selectNotificationKind;

@property (retain, nonatomic) NSMutableString *theResult;
@property (retain, nonatomic) NSMutableData  *theResultData;

//@property int chargePileNumber;
//@property NSMutableArray *muArray;

-(void)sendRequest:(NSString*)strAddress;
-(void)sendAsynchronousPostRequest;

//单独异步POST图片给服务器;
-(void)sendAsynchronousPostImageRequest:(UIImage*)image;

//单独POST 设置界面-》个人信息-》 名字、个性签名、微信号、Tesla车型字段，以及反馈与建议文字;
-(void)sendAsynchronousPostTextRequest:(NSString*)text type:(int)type;
//-(void)parseResult;

//-(void)parseDetailResult;



@end
