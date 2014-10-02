//
//  RequestAnnotationInfo.m
//  bix
//
//  Created by dsx on 14-10-1.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "RequestAnnotationInfo.h"
#import "MapViewController.h"

@implementation RequestAnnotationInfo
{
//    MapViewController *mapViewController;
}

//异步GET请求
-(void)sendRequest
{
    NSString *addStr = [NSString stringWithFormat:@"http://121.40.72.197/api/piles"];
    NSURL *url = [NSURL URLWithString:addStr];
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
    [self parseResult];
//    mapViewController = [[MapViewController alloc]init];
//    [mapViewController addBatteryChargeAnnotation];
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
//    NSString *temp;
//    NSError *error;
    NSDictionary *location = [NSJSONSerialization JSONObjectWithData:self.theResultData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arrayResult = [location objectForKey:@"result"];
//    
//    double t1, t2, t3, t4;
//    int k = 0;
//    [arrayResult count]
    NSLog(@"数组个数是%d", [arrayResult count]);
    _chargePileNumber = [arrayResult count];
    
//    CHARGE_PILE_NUMBER = _chargePileNumber;
    
    _muArray = [NSMutableArray arrayWithCapacity:_chargePileNumber*2];

    for (id obj1 in arrayResult) {
        
        NSDictionary *longitude = [obj1 objectForKey:@"pile"];
//        NSLog(@"longitude is:%@", longitude);
      
        NSLog(@"longitude is %@", [longitude objectForKey:@"longitude"]);
//        temp = [longitude objectForKey:@"longitude"];
        [_muArray addObject:[longitude objectForKey:@"longitude"]];
        [_muArray addObject:[longitude objectForKey:@"latitude"]];
    }
    for(id obj in _muArray)
    {
        NSLog(@"%@", obj);
    }
//        if(k == 0)
//        {
//            t1 = [temp doubleValue];
//            t2 = [[longitude objectForKey:@"latitude"] doubleValue];
//        }
//        else
//        {
//            t3 = [temp doubleValue];
//            t4 = [[longitude objectForKey:@"latitude"] doubleValue];
//        }
//        k++;
    
////    chargePileNumber = k;
//    NSLog(@"%.8f, %.8f, %.8f, %.8f", t1, t2, t3, t4);
//    NSDictionary * loc1 = [arrayResult objectAtIndex:0];
//    NSLog(@"loc1 is %@", loc1);
//    
//    NSDictionary *longitude = [loc1 objectForKey:@"pile"];
////    NSMutableString *str1 = [NSMutableString string];
////    NSDictionary *
////    str1 = [loc1 objectForKey:@"longitude"];
//    NSLog(@"longitude is:%@", longitude);
//    NSLog(@"longitude is %@", [longitude objectForKey:@"longitude"]);
//    NSRange range = [self.theResult rangeOfString:@"location"];
//    if (range.location == NSNotFound) {
//        NSLog(@"没找到");
//    }
//    else
//    {
//        NSLog(@"找到的范围是:%@", NSStringFromRange(range));
//    }
    

}


@end
