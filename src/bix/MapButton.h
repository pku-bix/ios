//
//  MapButton.h
//  bix
//
//  Created by dsx on 14-7-24.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"
#import "BMapKit.h"
#import "ButtonProtocal.h"

@interface MapButton : NSObject<ButtonProtocal>
{
    BMKMapView *_mapView;
    BMKSearch *_search;
    BMKUserLocation *current_Location;
    NSArray* array;
    
}

-(void)enlargeButtonClicked:(BMKMapView *)mapView;
-(void)shrinkButtonClicked:(BMKMapView *)mapView;
-(void)locateButtonClicked:(BMKMapView *)mapView;

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
-(void)compassButtonClicked:(BMKMapView *)mapView;

-(void)getCurrentButtonClicked:(BMKSearch*)search current_Location:(BMKUserLocation*)current_Location;
-(void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error BMapView:(BMKMapView*)mapView;

-(BMKUserLocation*)didUpdateUserLocation:(BMKUserLocation *)userLocation;
// once launch the baidu map, locate the position of user immediately
-(void)launchMapView_locate:(BMKMapView*)mapView;

@end
