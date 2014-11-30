//
//  bixMomentDataSource.m
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixMomentDataSource.h"
#import "Account.h"
#import "AppDelegate.h"

@interface bixMomentDataSource()

// 当前的操作
typedef enum{
    APPENDING,
    REFRESHING
}OperationType;

@property NSMutableArray* items;
@property OperationType operation;

@end


@implementation bixMomentDataSource

+(bixMomentDataSource*) defaultSource
{
    static bixMomentDataSource *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

-(void)initMomentDataItemsArray
{
    self.momentDataItemsArray = [NSMutableArray arrayWithCapacity:5];
}

-(BOOL) update
{
    self.operation = REFRESHING;
    return [bixAPIProvider Pull:self];
}

-(BOOL) loadMore
{
    self.operation = APPENDING;
    return [bixAPIProvider Pull:self];
}

#pragma mark RemoteModel DataSource

-(NSString*) modelPath{
    return @"/api/posts";
}


#pragma mark RemoteModel Delegate

-(void)PopulateWithData: (NSObject *)result{
    
    if (self.operation == REFRESHING) [self.items removeAllObjects];
    
    for (id resultItem in (NSArray*)result) {
        bixMomentDataItem* dataItem = [bixMomentDataItem new];
        [dataItem populateWithJSON:resultItem];
        [self.items addObject:dataItem];
    }
}


#pragma mark MomentDataSource

-(BOOL) addMomentDataItem: (bixMomentDataItem*)item{
    //todo: add item to itemsArray
    [self.momentDataItemsArray addObject:item];
    
    [self.observer modelUpdated:self];
    
    return true;
}

-(BOOL) removeMomentDataItem:(int)index
{
    if (index > [self.momentDataItemsArray count]) {
        return false;
    }
    else
    {
        [self.momentDataItemsArray removeObjectAtIndex:index];

        [self.observer modelUpdated:self];
        return true;
    }
    
    
}

-(int)numberOfMomentDataItem
{
    return [self.momentDataItemsArray count];
}

-(bixMomentDataItem*) getMomentAtIndex: (NSInteger) index
{
    return [self.momentDataItemsArray objectAtIndex:index];
}


@end
