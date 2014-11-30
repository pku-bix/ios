//
//  bixFormBuild.m
//  bix
//
//  Created by dsx on 14-11-30.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixFormBuild.h"

@implementation bixFormBuild
{
    
}
//静态类变量
static NSString *const boundary = @"PkuBixMustSuccess";

-(id)init
{
    self = [super init];
    if (self) {
        //记得为body申请内存空间;
        self.body = [NSMutableData new];
    }
    return self;
}


-(void)addPicture:(NSString *)name andImage:(UIImage *)image
{
    //image 参数传进来的image数据
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [self.body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"boris.png\"\r\n",name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.body appendData:[NSData dataWithData:imageData]];
    
    [self.body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

}

-(void)addText:(NSString *)name andText:(NSString *)text
{
    [self.body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
   [self.body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"boris.png\"\r\n",name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.body appendData:[[NSString stringWithString:text] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
}

-(NSData*)closeForm
{
    // close form
    [self.body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return self.body;
}

@end
