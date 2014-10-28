//
//  bixMomentReplyItem.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface bixMomentReplyItem : NSObject

@property (readonly,nonatomic) NSURL* avatarUrl;
@property (readonly) NSString* nickname;
@property (readonly) NSString* text;

-(id)initWithSender:(Account*) sender;
-(id)initWithSender:(Account*) sender andReplyText:(NSString*) text;

@end
