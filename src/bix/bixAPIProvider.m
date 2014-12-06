//
//  bixRemoteSync.m
//  bix
//
//  Created by harttle on 11/18/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixAPIProvider.h"
#import "Constants.h"

@interface bixAPIProvider()

// 操作类型
typedef enum {
    PULL,
    PUSH
}OperationType;

@property (retain, nonatomic) NSMutableData  *receiveBuffer;
@property (nonatomic) OperationType operation;
@property (nonatomic) NSHTTPURLResponse* response;
@property (nonatomic) NSMutableURLRequest* request;
@property (nonatomic) NSURL* url;

@end


@implementation bixAPIProvider{
    // 流控制：正在请求过程中不允许重复请求
    bool busy;
}

static NSString* errDomain = @"apiprovider";


// TODO: 初始化connection并开始请求
+(BOOL) Push: (id<bixRemoteModelDataSource, bixRemoteModelDelegate>) model{
    bixAPIProvider* p = [bixAPIProvider new];
    p.model = model;
    p.operation = PUSH;
    return [p startRequestWithOperation: PUSH];
}

// TODO: 初始化connection并开始请求
+(BOOL) Pull: (id<bixRemoteModelDelegate, bixRemoteModelDataSource>) model{
    bixAPIProvider* p = [bixAPIProvider new];
    p.model = model;
    p.operation = PULL;
    return [p startRequestWithOperation: PULL];
}

-(BOOL) startRequestWithOperation: (OperationType) operation{

    if(busy){
#ifdef DEBUG
        NSLog(@"api provider is busy, request omited");
#endif
        return NO;
    }
    busy = true;
    //创建请求
    self.url = [NSURL URLWithString:
                [NSString stringWithFormat:@"%@%@", API_SERVER, [self.model modelPath]]];
    NSLog(@"url is :%@", self.url);
    
    self.request = [NSMutableURLRequest requestWithURL:self.url
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    if (operation == PUSH) {
        [self.request setHTTPMethod:@"POST"];
        NSString *boundary = @"PkuBixMustSuccess";
        if ([self.model respondsToSelector: @selector(modelBody)]) {
            [self.request setHTTPBody:[self.model modelBody]];
            
            //设置HTTPHeader中Content-Type的值
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [self.request setValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            //设置Content-Length
            [self.request setValue:[NSString stringWithFormat:@"%d", [[self.model modelBody] length]] forHTTPHeaderField:@"Content-Length"];
        }
        self.operation = PUSH;
    }
    else if(operation == PULL)
    {
        [self.request setHTTPMethod:@"GET"];
        self.operation = PULL;
    }
    //创建连接
    [NSURLConnection connectionWithRequest:self.request delegate:self];
    return true;
}

//开始响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveBuffer = [NSMutableData data];
    self.response = (NSHTTPURLResponse*)response;
    
    if([self isRequestSuccess] && [self.model respondsToSelector:@selector(succeedWithStatus:)]){
        [self.model succeedWithStatus:self.response.statusCode];
    }
    else if([self isRequestError] && [self.model respondsToSelector:@selector(requestFailedWithError:)]){
        [self.model requestFailedWithError:
         [NSError errorWithDomain:errDomain code:self.response.statusCode
                         userInfo:[NSDictionary dictionaryWithObject:
                                   self.response forKey:@"response"]]];
    }
}

//收到数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveBuffer appendData:data];
}

//接收完毕
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSJSONReadingOptions options = NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers|NSJSONReadingAllowFragments;
    
    NSObject* json = [NSJSONSerialization
                      JSONObjectWithData:self.receiveBuffer
                      options: options
                      error:nil];

    if([self isRequestSuccess]){
        if([self.model respondsToSelector:@selector(populateWithJSON:)]){
            [self.model populateWithJSON:json];
        }

        if([self.model respondsToSelector:@selector(succeedWithStatus:andJSON:)]){
            [self.model succeedWithStatus:self.response.statusCode andJSON:json];
        }
    }

    busy = false;
}

//连接错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"连接错误：%@", [error localizedDescription]);
#endif
    if ([self.model respondsToSelector:@selector(connectionFailedWithError:)]) {
        [self.model connectionFailedWithError:error];
    }
    
    busy = false;
}


#pragma mark 工具函数

// 下拉请求是否成功
-(bool) isRequestSuccess{
    return self.response.statusCode == 200 || self.response.statusCode == 304;
}

// 下拉请求是否失败
-(bool) isRequestError{
    return self.response.statusCode == 400 || self.response.statusCode == 404;
}

@end
