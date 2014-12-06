//
//  bixImageProxy.m
//  bix
//
//  Created by dsx on 14-12-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixImageProxy.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Constants.h"

@implementation bixImageProxy

-(id)initWithUrl:(NSString *)url andThumbnail:(NSString*)thumbnail
{
    self = [super init];
    if (self) {
        self.url = url;
        self.thumbnailUrl = thumbnail;
    }
    return self;
}

-(id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}

-(void)setImageToImageView:(UIImageView *)imageView
{
    if (self.image == NULL) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER, self.url]]];
    }
    else{
        imageView.image = self.image;
    }
}




@end
