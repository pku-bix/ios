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


@implementation bixAPIProvider

static NSString* errDomain = @"apiprovider";


// TODO: 初始化connection并开始请求
+(bixAPIProvider*) Push: (id<bixRemoteModelDataSource, bixRemoteModelDelegate>) model{
    bixAPIProvider* p = [bixAPIProvider new];
    p.model = model;
    p.operation = PUSH;
    [p startRequestWithOperation: PUSH];
    return p;
}

// TODO: 初始化connection并开始请求
+(bixAPIProvider*) Pull: (id<bixRemoteModelDelegate, bixRemoteModelDataSource>) model{
    bixAPIProvider* p = [bixAPIProvider new];
    p.model = model;
    p.operation = PULL;
    [p startRequestWithOperation: PULL];
    return p;
}

-(bool) startRequestWithOperation: (OperationType) operation{
    self.url = [NSURL URLWithString:
                [NSString stringWithFormat:@"%@%@", API_SERVER, [self.model modelPath]]];
    //创建请求
    self.request = [NSMutableURLRequest requestWithURL:self.url
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60];
    switch (operation) {
        case PUSH:
            [self.request setHTTPMethod:@"POST"];
            [self.request setHTTPBody:[self.model modelBody]];
            self.operation = PUSH;
            break;
            
        case PULL:
            [self.request setHTTPMethod:@"GET"];
            self.operation = PULL;
            break;
            
        default:
            break;
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
    
    if([self isRequestSuccess]){
        [self.model succeedWithStatus:self.response.statusCode];
    }
    else if([self isRequestError]){
        [self.model requestFailedWithError:[NSError errorWithDomain:errDomain code:self.response.statusCode
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
        [self.model SucceedWithStatus:self.response.statusCode andJSONResult:json];
    }
}

//连接错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"错误信息是%@", [error localizedDescription]);
    [self.model connectionFailedWithError:error];
}

// 下拉请求是否成功
-(bool) isRequestSuccess{
    return self.response.statusCode == 200 || self.response.statusCode == 304;
}

// 下拉请求是否失败
-(bool) isRequestError{
    return self.response.statusCode == 400 || self.response.statusCode == 404;
}

@end
