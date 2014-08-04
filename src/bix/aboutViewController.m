//
//  aboutViewController.m
//  bix
//
//  Created by dsx on 14-8-4.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()

@end

@implementation aboutViewController
{
    CGRect rect;
    UITextView *_textView;
    UITextView *_textViewTitle;
    UITextView *contactUsTitle;
    UITextView *contactUs;
    NSString *aboutApp;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     rect = [[UIScreen mainScreen] bounds];
     UIImage *image = [UIImage imageNamed:@"Tesla.png"];
     UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
     imageView.frame = CGRectMake((rect.size.width-image.size.width)/2, 90, image.size.width, image.size.height);
     // imageView.backgroundColor = [UIColor greenColor];
     //imageView.contentMode = UIViewContentModeScaleAspectFill;
     [self.view addSubview:imageView];
     
     _textViewTitle = [[UITextView alloc] init];
     _textViewTitle.frame = CGRectMake((rect.size.width-image.size.width)/2-10, 90+image.size.height+20, image.size.width+30, 50);
     _textViewTitle.text = @"       关于Bix";
     _textViewTitle.font = [UIFont boldSystemFontOfSize:16];
     
     _textViewTitle.editable = NO;
     [self.view addSubview:_textViewTitle];
     
     _textView = [[UITextView alloc]init];
     _textView.frame = CGRectMake((rect.size.width-image.size.width)/2-25, 90+image.size.height+20+40, image.size.width+60, 150);
     aboutApp = @"本软件是一款集地图、社交、共享于一体的app，旨在通过地图和社交元素帮助电动汽车共享充电桩、共享汽车，从而方便用户，建立圈子.";
     _textView.text = aboutApp;
     _textView.font = [UIFont systemFontOfSize:15];
     //_textView.text = [_textView.text stringByAppendingString:aboutApp];
     
     _textView.editable = NO;
     [self.view addSubview: _textView];
    
    contactUsTitle = [[UITextView alloc]init];
    contactUsTitle.frame = CGRectMake((rect.size.width-image.size.width)/2-10, 90+image.size.height+20+30+150, image.size.width+30, 30);
    contactUsTitle.text = @"       联系我们";
    contactUsTitle.font = [UIFont boldSystemFontOfSize:16];
    contactUsTitle.editable = NO;
    [self.view addSubview:contactUsTitle];
    
    contactUs = [[UITextView alloc]init];
    contactUs.frame = CGRectMake((rect.size.width-image.size.width)/2-25, 90+image.size.height+20+30+180, image.size.width+60, 50);
    contactUs.text = @"    wolflzy@hotmail.com";
    contactUs.font = [UIFont boldSystemFontOfSize:16];
    contactUs.editable = NO;
    [self.view addSubview:contactUs];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
