//
//  RequestInfoFromServer.m
//  bix
//
//  Created by dsx on 14-10-8.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "RequestInfoFromServer.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation RequestInfoFromServer



//异步GET请求
-(void)sendRequest:(NSString*)strAddress
{
//    NSString *addStr = [NSString stringWithFormat:@"http://121.40.72.197/api/piles"];
    NSURL *url = [NSURL URLWithString:strAddress];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    //创建连接
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//异步POST请求,POST图片、文字
-(void)sendAsynchronousPostRequest
{
    _selectNotificationKind = 3;//第三种请求方式,区别于充电桩数据和单个充电桩详情的数据请求;
    
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    NSMutableString *url = [NSMutableString stringWithString:POST_IMAGE_TEXT_INFO_IP];
    [url appendString:account.username];
    NSLog(@"url is %@", url);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"PkuBixMustSuccess"; //分界线
    NSMutableData *body = [NSMutableData data]; //http body
    
    //image
    UIImage *image = [UIImage imageNamed:@"Tesla.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name=\"avatar\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Text parameter1
    NSString *param1 = @"test1, i am dsx";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"nickname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Another text parameter
    NSString *param2 = @"test2 my weChatID is dudududududu";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"wechat_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    //设置HTTPHeader中Content-Type的值
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    
    //设置http body
    [request setHTTPBody:body];
    
    
    //建立连接，设置代理
    [NSURLConnection  connectionWithRequest:request delegate:self];
    
//    NSString *picType
//    [body appendData: [NSString stringWithString:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"] ];
//    ////添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//    //声明pic字段，文件名为boris.png
//    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
//    //声明上传文件的格式
//    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
//    
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    
}
/*
 - (void) upload {
 NSString *urlString = @"http://www.examplescript.com";
 NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
 [request setURL:[NSURL URLWithString:urlString]];
 [request setHTTPMethod:@"POST"];
 
 NSMutableData *body = [NSMutableData data];
 
 
 NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
 NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
 [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
 
 // file
 NSData *imageData = UIImageJPEGRepresentation(imageView.image, 90);
 
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"userfile\"; filename=\".jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[NSData dataWithData:imageData]];
 [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 
 // Text parameter1
 NSString *param1 = @"parameter text";
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"parameter1\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 
 // Another text parameter
 NSString *param2 = @"Parameter 2 text";
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"parameter2\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 
 // close form
 [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 
 // set request body
 [request setHTTPBody:body];
 
 //return and test
 NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
 
 NSLog(@"%@", returnString);
 }
 */

//服务器开始响应请求,异步请求的代理方法;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    [response ]
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
//        NSDictionary *dictionary = [httpResponse allHeaderFields];
//        NSLog([dictionary description]);
//        [dictionary objectForKey:statusCode];
        NSLog(@"http 状态码是 %d",[httpResponse statusCode]);
    }
    NSLog(@"服务器开始响应请求");
    
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

/*
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
*/


@end
