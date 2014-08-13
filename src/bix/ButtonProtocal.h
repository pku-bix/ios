//
//  ButtonProtocal.h
//  bix
//
//  Created by dsx on 14-8-13.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ButtonProtocal <NSObject>

@required
-(void)createButton:(UIButton*)button image:(NSString *)imageName targerSelector:(NSString*)selector;

@end
