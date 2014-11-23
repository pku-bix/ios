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

@property NSMutableArray* items;

@end

@implementation bixMomentDataSource
{
    AppDelegate *appDelegate;
    // TODO: 测试数据，完成HTTP层后删除
    Account* account;
}

+(bixMomentDataSource*) defaultSource
{
//    // structure used to test whether the block has completed or not
//    static dispatch_once_t p = 0;
//    
//    // initialize sharedObject as nil (first call only)
//    __strong static id _sharedObject = nil;
//    
//    // executes a block object once and only once for the lifetime of an application
//    dispatch_once(&p, ^{
//        _sharedObject = [[self alloc] init];
//    });
//    
//    // returns the same object each time
//    return _sharedObject;
    
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
    return YES;
}

-(BOOL) loadMore
{
    return YES;
}

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
