//
//  MapViewController.m
//  bix
//
//  implement by dusx5
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
   
    _search = [[BMKSearch alloc]init];
   
    
    CGRect rect = [[UIScreen mainScreen] bounds];
  //  CGSize size = rect.size;
  //CGFloat width = size.width;
  //  CGFloat height = size.height;
    
    //_search.delegate = self;
    //_mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 50, 320, 500)];
//    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 500)];
    _mapView = [[BMKMapView alloc]initWithFrame:rect];
    _mapView.delegate = self;
    
    // once launch the baidu map, locate the position of user immediately
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
     //NSLog(@"_mapView.zoomLevel is %f",_mapView.zoomLevel);
    _mapView.zoomLevel = 15;   // make the zoomLevel = 15 so that once the app launches the map will have a fitness interface
    
    [self.view addSubview: _mapView];
    [self.view addSubview:followingBtn];
    [self.view addSubview:compass];
    [self.view addSubview:shareBtn];
    [self.view addSubview:magnifyBtn];
    [self.view addSubview:lessen];
    //[self.view addSubview:_search];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;   //此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self;  // 此处记得不用的时候需要置nil，否则影响内存的释放
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil; // 不用时，置nil
   // NSLog(@"map view disappear");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startFollow:(id)sender {
   // NSLog(@"进入跟随态");
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    //remove the annotation array of baidu mapview added
    array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    //remove the overlay infomation that baidu mapview has added, eg: navigation info.
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
}


- (IBAction)compassHeading:(id)sender {
    
   // NSLog(@"进入罗盘态");
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    _mapView.showsUserLocation = YES;
    
    //remove the annotation array of baidu mapview added
    array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    //remove the overlay infomation that baidu mapview has added, eg: navigation info.
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
     array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == 0) {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
		[_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.geoPt;
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

- (IBAction)getReverseGeoAddress:(id)sender {
    
    CLLocationCoordinate2D pt = {current_Location.location.coordinate.latitude,current_Location.location.coordinate.longitude};
    
    // CLLocationCoordinate2D pt = {22.599155,113.981154};
    
    //NSLog(@"经纬度：%f %f", current_Location.location.coordinate.latitude, current_Location.location.coordinate.longitude);
	
    BOOL flag = [_search reverseGeocode:pt];
    
	if (flag) {
		//NSLog(@"ReverseGeocode search success.");
        
	}
    else{
        //NSLog(@"ReverseGeocode search failed!");
    }
    
}

- (IBAction)enLarge:(id)sender {
   // NSLog(@"_mapView.zoomLevel is %f",_mapView.zoomLevel);
    if(_mapView.zoomLevel < 18)
    {
        _mapView.zoomLevel += 1;
    }
    else
    {
        _mapView.zoomLevel = 18;
    }
}

- (IBAction)zoomOut:(id)sender {
    //NSLog(@"_mapView.zoomLevel is %f",_mapView.zoomLevel);
    if(_mapView.zoomLevel > 3)
    {
        _mapView.zoomLevel -= 1;
    }
    else
    {
        _mapView.zoomLevel = 3;
    }
}


/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	//NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		//NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	}
	
    //CLLocation *currlocation = [userLocation lastObject];
    current_Location = userLocation;
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
   // NSLog(@"stop locate");
}


/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    //NSLog(@"location error");
}


@end
