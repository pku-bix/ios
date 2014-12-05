//
//  CustomBMKPointAnnotation.h
//  bix
//
//  Created by dsx on 14-10-26.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "BMKPointAnnotation.h"
#import "bixCharger.h"

@interface bixChargerPointAnnotation : BMKPointAnnotation

@property (nonatomic) bixCharger* charger;

-(id) initWithCharger:(bixCharger*)charger;

@end
