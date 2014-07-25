//
//  MapButton.m
//  bix
//
//  Created by dsx on 14-7-24.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MapButton.h"
#import "MapViewController.h"

@implementation MapButton
{
    CGRect rect;
    UIImage *image;
}

-(void)enLargeButton:(UIButton*)writeButton
{
    rect = [[UIScreen mainScreen]bounds];
    //    设置按钮类型，此处为圆角按钮
    image= [UIImage imageNamed:@"plus2-64.png"];
    
    //writeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [writeButton setBackgroundImage:image forState:UIControlStateNormal];

    //    设置和大小
    CGRect frame = CGRectMake(rect.size.width-35, rect.size.height-150, 32, 32);
    //    将frame的位置大小复制给Button
    writeButton.frame = frame;
    
    //-----------------------------------------------
    //  给Button添加标题
    //[writeButton setTitle:@"代码按钮" forState:UIControlStateNormal];
    //   设置按钮背景颜色
   // writeButton.backgroundColor = [UIColor clearColor];
    //  设置按钮标题文字对齐方式，此处为左对齐
    //writeButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    //使文字距离做边框保持10个像素的距离。
   // writeButton.contentEdgeInsets = UIEdgeInsetsMake(0,30, 0, 0);
    //----------------------------------------------------
    
    /******************************************************
     //此处类容目的掩饰代码代码操作按钮一些属性，如果设置按钮背景为图片可以将此处注释取消，注释掉上没横线范围类代码，进行测试
     
     //    设置按钮背景图片
     UIImage *image= [UIImage imageNamed:@"background.png"];
     
     [writeButton setBackgroundImage:image forState:UIControlStateNormal];
     //  按钮的相应事件
     
     *****************************************************/
    [writeButton addTarget:self action:@selector(buttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:writeButton];
}

//弹出一个警告，一般都这样写
-(void) buttonClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了一个按钮" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"test1",@"test2",@"test3",@"test4", nil];
    [alert show];
}


@end
