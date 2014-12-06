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

-(id)initWithCoder:(NSCoder *)coder{
    self = [super init];
    
    if (self) {
        self.url = [coder decodeObjectForKey:@"url"];
        self.thumbnailUrl = [coder decodeObjectForKey:@"thumbnail"];
        self.image = [coder decodeObjectForKey:@"image"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.thumbnailUrl forKey:@"thumbnail"];
    [coder encodeObject:self.image forKey:@"image"];
}

-(void)setImageToImageView:(UIImageView *)imageView
{
    if (self.image == NULL) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.url]];
    }
    else{
        imageView.image = self.image;
    }
}




@end
