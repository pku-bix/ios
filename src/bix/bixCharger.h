//
//  bixCharger.h
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixRemoteModelDataSource.h"
#import "bixRemoteModelDelegate.h"
#import "bixRemoteModelBase.h"

@interface bixCharger : bixRemoteModelBase<bixRemoteModelDataSource, bixRemoteModelDelegate>

@property (nonatomic) NSString * detailedAddress;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int parkingnum;

@end
