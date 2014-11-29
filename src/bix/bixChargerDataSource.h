//
//  bixChargerDataSource.h
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bixCharger.h"
#import "bixRemoteModelDelegate.h"
#import "bixRemoteModelDataSource.h"

@interface bixChargerDataSource : bixRemoteModelBase<bixRemoteModelDataSource, bixRemoteModelDelegate>
{
}
// 所有充电桩
@property NSMutableDictionary* chargers;

-(void) pullChargerById: (NSString*)id;
-(void) pullChargers;

+(bixChargerDataSource*) defaultSource;


@end
