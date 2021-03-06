//
//  MapViewController.h
//  bix
//
//  implement by dusx5
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "UzysSlideMenu.h"
#import "bixRemoteModelObserver.h"

@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate,NSURLConnectionDataDelegate, bixRemoteModelObserver>
{    
//    BMKMapView *_mapView;
//    __weak IBOutlet BMKMapView *_mapView;
    
    IBOutlet BMKMapView *_mapView;
    BMKSearch *_search;
    BMKUserLocation *current_Location;
    NSArray* array;
    int chargePileNumber;
    //存储从服务器获取充电桩数据的数组
    NSMutableArray *muArray;
    //存储点击callout地图标注时具体充电桩数据的数组
    NSMutableArray*detailInfoArray;
}

@property (nonatomic,strong) UzysSlideMenu *chargerMenu;
@property (weak, nonatomic)UIButton *chargerItem;
@property (retain, nonatomic) NSMutableString *theResult;
@property (retain, nonatomic) NSMutableData  *theResultData;

-(void)parseResult:(NSNotification*)notification;
-(void)parseDetailResult:(NSNotification*)notification;

@end
