//
//  bixImageProxy.h
//  bix
//
//  Created by dsx on 14-12-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bixImageProxy : NSObject

@property (nonatomic)NSString *url;
@property (nonatomic)UIImage *image;


-(id)initWithUrl:(NSString *)url;
-(id)initWithImage:(UIImage *)image;
-(void)setImageToImageView:(UIImageView *)imageView;

@end
