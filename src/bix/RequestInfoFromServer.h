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

//用于区分是哪种请求，以便发出相应的通知;
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

//上报充电桩，Post用户名、电话、详细地址、经纬度，这四个必填字段，邮箱、充电桩数量、备注选填;
-(void)sendAsynchronousPostReportChargerRequest:(NSMutableArray*)mutableArray;

//发送分享圈的文字和图片给服务器;
-(void)sendAsynchronousPostMomentData:(NSMutableArray*)mutableArray;

//向用户推送通知时，需要知道用户的deviceToken，向用户post此deviceToken;
-(void)sendAsynchronousPostDeviceToken:(NSData *)deviceToken;

//-(void)parseResult;

//-(void)parseDetailResult;



@end