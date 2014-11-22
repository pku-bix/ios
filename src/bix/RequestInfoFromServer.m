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



//异步GET请求 获取 所有充电桩数据, 以及获取某个充电桩的详情, 这两种情况只是请求的参数不同而已;
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

//单独异步POST图片给服务器; 用于发送头像给服务器;
-(void)sendAsynchronousPostImageRequest:(UIImage*)image
{
    _selectNotificationKind = 3;//第三种请求方式,区别于充电桩数据和单个充电桩详情的数据请求;
    
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    //static NSString *const POST_IMAGE_TEXT_INFO_IP = @"http://121.40.72.197/api/user/";
//    NSMutableString *post_image_text_info_ip;
//    [post_image_text_info_ip setString:NODE_SERVER_OR_LAN_SERVER];
//    [post_image_text_info_ip appendString:<#(NSString *)#>]
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
    _selectNotificationKind = 4;//第三种请求方式,区别于充电桩数据和单个充电桩详情的数据请求;
    
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

//上报充电桩数据;
-(void)sendAsynchronousPostReportChargerRequest:(NSMutableArray *)mutableArray
{
    //dictionary 对象下标从小到大顺序为:用户ID、经度、维度、电话号码、详细地址、邮箱地址、充电桩数量、备注信息;后三个字段是用户上报时的选填字段，不是必填字段;
    
    _selectNotificationKind = 6;//第三种请求方式,区别于充电桩数据和单个充电桩详情的数据请求;
    
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

//发送  分享圈  的文字和图片给服务器
-(void)sendAsynchronousPostMomentData:(NSMutableArray *)mutableArray
{
    _selectNotificationKind = 5;//第5种请求方式,区别于充电桩数据和单个充电桩详情的数据请求;
    
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    NSLog(@"author name is %@", account.username);
    //分享圈输入的发送 文字;
    NSString *momentText = [mutableArray objectAtIndex:([mutableArray count]-1)];
    
    NSMutableString *url = [NSMutableString stringWithString:POST_MOMENT_IP];
    //    [url appendString:account.username];
    NSLog(@"url is %@", url);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"PkuBixMustSuccess"; //分界线
    NSMutableData *body = [NSMutableData data]; //http body
    
    
    //发送 author 字段
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"author\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:account.username] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //发送 输入的text字段
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"text\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:momentText] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //发送 用户添加的 图片
    //image 参数传进来的image数据
    int pictureNumber = [mutableArray count] - 1; // 用户添加的图片个数 = 数组元素个数 减去 一个text元素;
    
    for (int k = 0; k < pictureNumber; k++) {
        
        NSData *imageData = UIImagePNGRepresentation([mutableArray objectAtIndex:k]);
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        switch (k) {
            case 0:
                [body appendData:[@"Content-Disposition: form-data; name=\"img0\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;
            case 1:
                [body appendData:[@"Content-Disposition: form-data; name=\"img1\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;
            case 2:
                [body appendData:[@"Content-Disposition: form-data; name=\"img2\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;
            case 3:
                [body appendData:[@"Content-Disposition: form-data; name=\"img3\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;
            case 4:
                [body appendData:[@"Content-Disposition: form-data; name=\"img4\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;
            case 5:
                [body appendData:[@"Content-Disposition: form-data; name=\"img5\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;
            case 6:
                [body appendData:[@"Content-Disposition: form-data; name=\"img6\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;
            case 7:
                [body appendData:[@"Content-Disposition: form-data; name=\"img7\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;
            case 8:
                [body appendData:[@"Content-Disposition: form-data; name=\"img8\"; filename=\"boris.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                break;

            default:
                break;
        }
        
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
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
    _selectNotificationKind = 7;//第三种请求方式,区别于充电桩数据和单个充电桩详情的数据请求;
    
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


//向用户推送通知时，需要知道用户的deviceToken，向用户post此deviceToken;
-(void)sendAsynchronousPostDeviceToken:(NSData *)deviceToken
{
    _selectNotificationKind = 8;//第三种请求方式,区别于充电桩数据和单个充电桩详情的数据请求;
    
    Account *account = [(AppDelegate*)[UIApplication sharedApplication].delegate account];
    NSMutableString *url = [NSMutableString stringWithString:POST_DEVICE_TOKEN_IP];
    [url appendString:account.username];
    NSLog(@"url is %@", url);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"PkuBixMustSuccess"; //分界线
    NSMutableData *body = [NSMutableData data]; //http body
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"deviceToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:momentText] dataUsingEncoding:NSUTF8StringEncoding]];
    //将deviceToken 从NSData转化成 NSString;
    NSString * temp = [[NSString alloc]initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
    [body appendData:[[NSString stringWithString:temp] dataUsingEncoding:NSUTF8StringEncoding]];
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
        if (_selectNotificationKind == 5) {
//            if ([httpResponse statusCode] == 200) {
            
//                NSLog(@"http statusCode is %d", [httpResponse statusCode]);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"sendMomentDataSuccessOrNot" object:@"success"];
//            }
//            else
//            {
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"sendMomentDataSuccessOrNot" object:@"serverProblem"];
//            }
        }
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
    else if (_selectNotificationKind == 2)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:REQUEST_CHARGER_DETAIL_INFO object:self.theResultData];
    }
    else if(_selectNotificationKind == 5) //发送分享圈的响应数据;
    {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"returnMomentData" object:self.theResultData];
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
    NSLog(@"错误信息是%@", [error localizedDescription]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendMomentDataSuccessOrNot" object:@"networkLost"];
}

@end
