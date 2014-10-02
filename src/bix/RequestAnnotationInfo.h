//
//  RequestAnnotationInfo.h
//  bix
//
//  Created by dsx on 14-10-1.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "MapViewController.h"

@interface RequestAnnotationInfo : NSObject<NSURLConnectionDataDelegate>
{
//    int chargePileNumber;
    MapViewController *mapViewController;
//    NSMutableArray *muArray;
}

@property (retain, nonatomic) NSMutableString *theResult;
@property (retain, nonatomic) NSMutableData  *theResultData;

@property int chargePileNumber;
@property NSMutableArray *muArray;

-(void)sendRequest;
-(void)parseResult;
@end
