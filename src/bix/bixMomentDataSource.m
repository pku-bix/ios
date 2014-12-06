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

@property NSMutableArray* items;   //缺少对其的初始化创建;
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

//-(void)initMomentDataItemsArray
//{
//    self.momentDataItemsArray = [NSMutableArray arrayWithCapacity:5];
//}

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
    return @"/api/posts";
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


#pragma mark MomentDataSource

-(BOOL) addMomentDataItem: (bixMomentDataItem*)item{
    //todo: add item to itemsArray
    [self.momentDataItemsArray addObject:item];
    
//    [self.observer modelUpdated:self];

    [super modelUpdateComplete];
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
    return [self.items count];
}

-(bixMomentDataItem*) getMomentAtIndex: (NSInteger) index
{
    return [self.items objectAtIndex:index];
}


@end
