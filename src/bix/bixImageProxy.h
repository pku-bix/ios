//
//  bixImageProxy.h
//  bix
//
//  Created by dsx on 14-12-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bixImageProxy : NSObject<NSCoding>

@property (nonatomic)NSString *url;
@property (nonatomic)UIImage *image;
@property (nonatomic)NSString *thumbnailUrl;


-(id)initWithUrl:(NSString *)url andThumbnail:(NSString*)thumbnail;
-(id)initWithImage:(UIImage *)image;

-(void)setImageToImageView:(UIImageView *)imageView;

@end
