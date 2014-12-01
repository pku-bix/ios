//
//  bixFormBuild.h
//  bix
//
//  Created by dsx on 14-11-30.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bixFormBuild : NSObject
{
   
}

//post的body属性;
@property(nonatomic)NSMutableData *body;

//添加post图片对应的body; 参数为对应的name字段和image数据字段,key-value对;
-(void)addPicture:(NSString *)name andImage:(UIImage *)image;

//添加post文字对应的body;
-(void)addText:(NSString *)name andText:(NSString *)text;

//结束body的添加工作;
-(NSData*)closeForm;



@end
