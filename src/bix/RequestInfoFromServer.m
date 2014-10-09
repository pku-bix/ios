//
//  RequestInfoFromServer.m
//  bix
//
//  Created by dsx on 14-10-8.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "RequestInfoFromServer.h"
#import "Constants.h"

@implementation RequestInfoFromServer



//异步GET请求
-(void)sendRequest:(NSString*)strAddress
{
//    NSString *addStr = [NSString stringWithFormat:@"http://121.40.72.197/api/piles"];
    NSURL *url = [NSURL URLWithString:strAddress];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    //创建连接
    [NSURLConnection connectionWithRequest:request delegate:self];
}


//服务器开始响应请求
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.theResult = [NSMutableString string];
    self.theResultData = [NSMutableData data];
}

//开始接受数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.theResultData appendData:data];
}

//数据接受完毕
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //把返回的data型数据转化成NSString
    self.theResult = [[NSMutableString alloc]initWithData:self.theResultData encoding:NSUTF8StringEncoding];
    //打印服务器返回的数据
    NSLog(@"result from server: %@", self.theResult);
    if (_selectNotificationKind == 1) {
         [[NSNotificationCenter defaultCenter]postNotificationName:REQUEST_SIMPLE_INFO object:self.theResultData];
    }
    else if (_selectNotificationKind ==2)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:REQUEST_CHARGER_DETAIL_INFO object:self.theResultData];
    }
    //    [self parseResult];
    //    mapViewController = [[MapViewController alloc]init];
    //    [mapViewController addBatteryChargeAnnotation];
}
-(void)selectNotification:(int) kind
{
    if (kind == 1) {
         [[NSNotificationCenter defaultCenter]postNotificationName:REQUEST_SIMPLE_INFO object:self.theResultData];
    }
    else if(kind == 2)
    {
         [[NSNotificationCenter defaultCenter]postNotificationName:REQUEST_CHARGER_DETAIL_INFO object:self.theResultData];
    }
}

//请求错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //打印错误信息
    NSLog(@"%@", [error localizedDescription]);
}


//解析从服务器获取的数据
-(void)parseResult
{
    NSDictionary *location = [NSJSONSerialization JSONObjectWithData:self.theResultData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arrayResult = [location objectForKey:@"result"];
    NSLog(@"数组个数是%d", [arrayResult count]);
    chargePileNumber = [arrayResult count];
    
    muArray = [NSMutableArray arrayWithCapacity:chargePileNumber*5];
    
    for (id obj1 in arrayResult) {
        [muArray addObject:[obj1 objectForKey:@"type"]];
        [muArray addObject:[obj1 objectForKey:@"detailedaddress"]];
        [muArray addObject:[obj1 objectForKey:@"latitude"]];
        [muArray addObject:[obj1 objectForKey:@"longitude"]];
        [muArray addObject:[obj1 objectForKey:@"_id"]];
    }
    for(id obj in muArray)
    {
        NSLog(@"muArray %@", obj);
    }
    //    NSLog(@"%.8f, %.8f, %.8f, %.8f", t1, t2, t3, t4);
    //    NSRange range = [self.theResult rangeOfString:@"location"];
    //    if (range.location == NSNotFound) {
    //        NSLog(@"没找到");
    //    }
    //    else
    //    {
    //        NSLog(@"找到的范围是:%@", NSStringFromRange(range));
    //    }
}

-(void)parseDetailResult
{
    NSDictionary *location = [NSJSONSerialization JSONObjectWithData:self.theResultData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arrayResult = [location objectForKey:@"result"];
    NSLog(@"充电桩详情的个数是%d", [arrayResult count]);
    //    NSLog(@"arrayResult is %@", arrayResult);
    //    chargePileNumber = [arrayResult count];
    
    //    muArray = [NSMutableArray arrayWithCapacity:chargePileNumber*5];
    [detailInfoArray removeAllObjects];
    NSLog(@"type is %@", [(id)arrayResult objectForKey:@"type"]);
    NSLog(@"detailedaddress is %@", [(id)arrayResult objectForKey:@"detailedaddress"]);
    NSLog(@"parkingnum is %@", [(id)arrayResult objectForKey:@"parkingnum"]);
    //    NSLog(@"time is %@", [(id)arrayResult objectForKey:@"time"]);
    
    if ([[(id)arrayResult objectForKey:@"type"] isEqualToString:@"superCharger"]) {
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"type"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"detailedaddress"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"parkingnum"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"time"]];
    }
    else if([[(id)arrayResult objectForKey:@"type"] isEqualToString:@"destinationCharger"])
    {
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"type"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"detailedaddress"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"parkingnum"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"info"]];
    }
    
    for (id obj in detailInfoArray) {
        NSLog(@"%@", obj);
    }
}



@end
