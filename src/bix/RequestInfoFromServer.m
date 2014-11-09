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

//单独异步POST图片给服务器;
-(void)sendAsynchronousPostImageRequest:(UIImage*)image
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
    
    //image 参数传进来的image数据
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name=\"avatar\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
    
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
}

//单独POST 设置界面-》个人信息-》 名字、个性签名、微信号、Tesla车型字段，以及反馈与建议文字;
-(void)sendAsynchronousPostTextRequest:(NSString*)text type:(int)type
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
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //上传名字字段
    if (type == NAME_TYPE) {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"nickname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //上传微信号 字段
    else if(type == WE_CHAT_ID_TYPE)
    {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"wechat_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithString:text] dataUsingEncoding:NSUTF8StringEncoding]];
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
}


-(void)sendAsynchronousPostReportChargerRequest:(NSMutableArray *)mutableArray
{
    //dictionary 对象下标从小到大顺序为:用户ID、经度、维度、电话号码、详细地址、邮箱地址、充电桩数量、备注信息;后三个字段是用户上报时的选填字段，不是必填字段;
    
    _selectNotificationKind = 3;//第三种请求方式,区别于充电桩数据和单个充电桩详情的数据请求;
    
    //    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    
    NSMutableString *url = [NSMutableString stringWithString:REPORT_CHARGER_INFO_IP];
    //    [url appendString:account.username];
    NSLog(@"url is %@", url);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"PkuBixMustSuccess"; //分界线
    NSMutableData *body = [NSMutableData data]; //http body

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //用户ID
    [body appendData:[[NSString stringWithString:[mutableArray objectAtIndex:0]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"longitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //经度
    [body appendData:[[NSString stringWithString:[mutableArray objectAtIndex:1]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"latitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //维度
    [body appendData:[[NSString stringWithString:[mutableArray objectAtIndex:2]] dataUsingEncoding:NSUTF8StringEncoding]];
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

//服务器开始响应请求,异步请求的代理方法;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    [response ]
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
//        NSDictionary *dictionary = [httpResponse allHeaderFields];
//        NSLog([dictionary description]);
//        [dictionary objectForKey:statusCode];
        NSLog(@"http statusCode is %d",[httpResponse statusCode]);
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
