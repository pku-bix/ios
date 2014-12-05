//
//  CustomBMKPointAnnotation.m
//  bix
//
//  Created by dsx on 14-10-26.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixChargerPointAnnotation.h"

@implementation bixChargerPointAnnotation

-(id)initWithCharger:(bixCharger *)charger{
    self = [super init];
    if (self) {
        self.charger = charger;
        self.coordinate = CLLocationCoordinate2DMake(charger.latitude, charger.longitude);
        self.title = charger.address;
//        self.type = 1; // type = 1; 表示目的充电桩;
    }
    return self;
}

@end
