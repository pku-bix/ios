//
//  bixRemoteModelObserver.h
//  bix
//
//  Created by harttle on 11/18/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModelDataSource.h"

@protocol bixRemoteModelObserver <NSObject>


@optional

-(void) modelUpdated: (id) model;

-(void)pushDidSuccess;

-(void)connectFailWithError;

@end
