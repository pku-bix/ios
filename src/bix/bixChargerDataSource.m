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

-(void) pullChargers{
    [bixAPIProvider Pull: self];
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

-(void) SucceedWithStatus: (NSInteger) code andJSONResult: (NSObject*) result{
    [self.chargers removeAllObjects];
    
    for (id obj in (NSArray*)result) {
        bixCharger* charger = nil;
        
        NSString* type = [obj objectForKey:@"__t"];
        
        NSLog(@"%@, %d", type, [type isEqualToString:@"DestCharger"]);
        
        if([type isEqualToString:@"DestCharger"]){
            charger = [bixDestCharger new];
        }
        else if([type isEqualToString:@"HomeCharger"]){
            //continue;
            charger = [bixHomeCharger new];
        }
        else if([type isEqualToString:@"SuperCharger"]){
//            continue;
            charger = [bixSuperCharger new];
        }
        
        charger.modelId = [obj objectForKey:@"_id"];
        charger.latitude = [[obj objectForKey:@"latitude"] doubleValue];
        charger.longitude = [[obj objectForKey:@"longitude"] doubleValue];
        charger.detailedAddress = [obj objectForKey:@"detailedaddress"];
        
        [self.chargers setObject:charger forKey:charger.modelId];
    }
    [self.observer modelUpdated: self];
}

@end
