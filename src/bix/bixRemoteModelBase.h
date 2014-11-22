//
//  bixRemoteModelBase.h
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModel.h"

@interface bixRemoteModelBase : NSObject

@property id<bixRemoteModelObserver> observer;

@end
