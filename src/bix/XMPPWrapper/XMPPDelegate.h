//
//  XMPPDelegate.h
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "Account.h"

@interface XMPPDelegate : NSObject 

@property (nonatomic, retain) Account* account;

-(id)init;

@end
