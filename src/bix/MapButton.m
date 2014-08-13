//
//  MapButton.m
//  bix
//
//  Created by dsx on 14-7-24.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MapButton.h"
#import "MapViewController.h"

@implementation MapButton
{
    CGRect rect;
    UIImage *image;
}


//弹出一个警告，一般都这样写
-(void) buttonClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了一个按钮" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"test1",@"test2",@"test3",@"test4", nil];
    [alert show];
}

#pragma mark five_mapButton_events

-(void) enlargeButtonClicked:(BMKMapView *)mapView
{
    if(mapView.zoomLevel < 21)
    {
        mapView.zoomLevel += 1;
    }
    else
    {
        mapView.zoomLevel = 21;
    }
}

-(void) shrinkButtonClicked:(BMKMapView *)mapView
{
    if(mapView.zoomLevel > 3)
    {
        mapView.zoomLevel -= 1;
    }
    else
    {
        mapView.zoomLevel = 3;
    }
}

-(void) locateButtonClicked:(BMKMapView *)mapView
{
    mapView.showsUserLocation = NO;
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    mapView.showsUserLocation = YES;
    
    //remove the annotation array of baidu mapview added
    array = [NSArray arrayWithArray:mapView.annotations];
	[mapView removeAnnotations:array];
    
    //remove the overlay infomation that baidu mapview has added, eg: navigation info.
	array = [NSArray arrayWithArray:mapView.overlays];
	[mapView removeOverlays:array];
}

-(void)compassButtonClicked:(BMKMapView *)mapView
{
    // NSLog(@"进入罗盘态");
    mapView.showsUserLocation = NO;
    mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    mapView.showsUserLocation = YES;
    
    //remove the annotation array of baidu mapview added
    array = [NSArray arrayWithArray:mapView.annotations];
	[mapView removeAnnotations:array];
    
    //remove the overlay infomation that baidu mapview has added, eg: navigation info.
	array = [NSArray arrayWithArray:mapView.overlays];
	[mapView removeOverlays:array];
}

-(void)getCurrentButtonClicked:(BMKSearch*)search current_Location:(BMKUserLocation*)currentLocation
{
    CLLocationCoordinate2D pt = {currentLocation.location.coordinate.latitude,currentLocation.location.coordinate.longitude};
    BOOL flag = [search reverseGeocode:pt];
	if (flag) {
		//NSLog(@"ReverseGeocode search success.");
        
	}
    else{
        //NSLog(@"ReverseGeocode search failed!");
    }
}

-(void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error BMapView:(BMKMapView*)mapView
{
    array = [NSArray arrayWithArray:mapView.annotations];
	[mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:mapView.overlays];
	[mapView removeOverlays:array];
	if (error == 0) {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
		[mapView addAnnotation:item];
        mapView.centerCoordinate = result.geoPt;
        NSString* titleStr;
        NSString* showmeg;
        /*if(isGeoSearch)
         {
         titleStr = @"正向地理编码";
         showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
         }
         else
         {*/
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        //}
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        
        [myAlertView show];
        //[myAlertView release];
        //		[item release];
    }
}

-(BMKUserLocation*)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation != nil) {
		//NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	}
    //CLLocation *currlocation = [userLocation lastObject];
    return userLocation;

}
// once launch the baidu map, locate the position of user immediately
-(void)launchMapView_locate:(BMKMapView*)mapView
{
    mapView.showsUserLocation = NO;
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    mapView.showsUserLocation = YES;
    // make the zoomLevel = 15 so that once the app launches the map will have a fitness interface
    mapView.zoomLevel = 15; 
}

-(void)createButton:(UIButton*)button image:(NSString *)imageName targerSelector:(NSString*)selector
{
    //缩小按钮的代码实现
    image = [UIImage imageNamed:imageName];
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    //设置位置和大小
    button.frame = CGRectMake(rect.size.width-50, rect.size.height-110, 32, 32);
    [button addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
}

@end