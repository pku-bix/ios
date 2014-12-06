//
//  bixImageProxy.m
//  bix
//
//  Created by dsx on 14-12-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixImageProxy.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation bixImageProxy

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

-(id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
//        self.image = [UIImage imageWithCIImage:<#(CIImage *)#>]
        self.image = image;
    }
    return self;
}

-(void)setImageToImageView:(UIImageView *)imageView
{
    if (self.image == NULL) {
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.url]];
    }
    else
    {
        imageView.image = self.image;
    }
}




@end
