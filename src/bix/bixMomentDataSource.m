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

@property NSMutableArray* items;   //momentDataItem 数组;
@property OperationType operation;

@end


@implementation bixMomentDataSource

+(bixMomentDataSource*) defaultSource
{
    static bixMomentDataSource *instance = nil;
    @synchronized(self) {
        if (instance == nil)
        {
            instance = [[self alloc] init];
            instance.items = [NSMutableArray new];
        }
    }
    return instance;
}

-(void) pull
{
    self.operation = REFRESHING;
    [bixAPIProvider Pull:self];
}

-(BOOL) loadMore
{
    self.operation = APPENDING;
    return [bixAPIProvider Pull:self];
}

#pragma mark RemoteModel DataSource

-(NSString*) modelPath{
    if (self.operation == APPENDING) {
        NSString *modelId = [(bixMomentDataItem*)self.items.lastObject modelId];
        if (modelId != nil && ![modelId isEqualToString:@""]) {
            return [NSString stringWithFormat:@"%@%@",@"/api/posts?limit=10&before=",modelId];
        }
    }
    return @"/api/posts?limit=10";
}



#pragma mark RemoteModel Delegate

-(void)populateWithJSON: (NSObject *)result{
    if (self.operation == REFRESHING) [self.items removeAllObjects];
    
    for (id resultItem in (NSArray*)result) {
        bixMomentDataItem* dataItem = [bixMomentDataItem new];
        [dataItem populateWithJSON:resultItem];
        [self.items addObject:dataItem];
        
    }
    [super modelUpdateComplete];
}

-(void)connectionFailedWithError:(NSError *)err
{
//    [super connectionFailedWithError:err];
    [self.observer connectFailWithError];
}

#pragma mark MomentDataSource

-(BOOL) addMomentDataItem: (bixMomentDataItem*)item{
    //todo: add item to itemsArray
//    [self.items addObject:item];
    //将新的item加在数组首位置;
    [self.items insertObject:item atIndex:0];
    
//    [self.observer modelUpdated:self];

    [super modelUpdateComplete];
    return true;
}

-(BOOL) removeMomentDataItem:(int)index
{
    if (index >= [self.items count]) {
        return false;
    }
    else
    {
        [self.items removeObjectAtIndex:index];

        [self.observer modelUpdated:self];
        return true;
    }
    
    
}

-(int)numberOfMomentDataItem
{
    return [self.items count];
}

-(bixMomentDataItem*) getMomentAtIndex: (NSInteger) index
{
    return [self.items objectAtIndex:index];
}


@end
