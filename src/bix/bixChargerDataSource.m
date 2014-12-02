//
//  bixChargerDataSource.m
//  bix
//
//  Created by dsx on 14-11-22.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixChargerDataSource.h"
#import "bixAPIProvider.h"
#import "bixDestCharger.h"
#import "bixHomeCharger.h"
#import "bixSuperCharger.h"

@interface bixChargerDataSource()


@end


@implementation bixChargerDataSource


+(bixChargerDataSource*) defaultSource
{
    static bixChargerDataSource *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

-(id) init{
    self = [super init];
    if (self) {
        self.chargers = [NSMutableDictionary new];
    }
    return self;
}


-(void) pullChargerById: (NSString*)modelId{
    bixCharger* charger = [self.chargers objectForKey:modelId];
    [bixAPIProvider Pull:charger];
}

#pragma mark RemoteModel DataSource

-(NSString*) modelPath{
    return @"/api/chargers";
}

#pragma mark RemoteModel Delegate
//将充电桩数据分别封装进三种不同充电桩对象里面;

-(void) populateWithJSON:(NSObject *)result{
    [self.chargers removeAllObjects];
    
    @try {
        for (id obj in (NSArray*)result) {
            bixCharger* charger = nil;
            
            NSString* type = [obj objectForKey:@"type"];
            
            if([type isEqualToString:@"DestCharger"]){
                charger = [bixDestCharger new];
                charger.chargerType = @"目的充电桩";
            }
            else if([type isEqualToString:@"HomeCharger"]){
                charger = [bixHomeCharger new];
                charger.chargerType = @"家庭充电桩";
            }
            else if([type isEqualToString:@"SuperCharger"]){
                charger = [bixSuperCharger new];
                charger.chargerType = @"超级充电桩";
            }
            
            charger.modelId = [obj objectForKey:@"id"];
            charger.latitude = [[obj objectForKey:@"latitude"] doubleValue];
            charger.longitude = [[obj objectForKey:@"longitude"] doubleValue];
            charger.address = [obj objectForKey:@"address"];
            
            [self.chargers setObject:charger forKey:charger.modelId];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parse charger datasource error: %@", exception);
    }
    [self.observer modelUpdated: self];
}

@end
