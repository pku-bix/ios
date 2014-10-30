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
//-(void)parseResult;

//-(void)parseDetailResult;



@end
