//
//  MapViewController.m
//  bix
//
//  implement by dusx5
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MapViewController.h"
#import "MapButton.h"

@implementation MapViewController
{
    UIButton* enlargeButton;
    UIButton* shrinkButton;
    UIButton* locateButton;
    UIButton* compassButton;
    UIButton* getCurrentLocationBtn;
    UIImage *image;
    CGRect rect;
}

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
    _search = [[BMKSearch alloc]init ];
    rect = [[UIScreen mainScreen] bounds];
    //  CGSize size = rect.size;   CGFloat width = size.width;  CGFloat height = size.height;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-40)];
    _mapView.delegate = self;
    
    // once launch the baidu map, locate the position of user immediately
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 15;   // make the zoomLevel = 15 so that once the app launches the map will have a fitness interface
    
    //放大按钮的代码实现
    image= [UIImage imageNamed:@"plus2-64.png"];
    enlargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [enlargeButton setBackgroundImage:image forState:UIControlStateNormal];
    //    设置和大小
    CGRect frame = CGRectMake(rect.size.width-50, rect.size.height-150, 32, 32);
    //    将frame的位置大小复制给Button
    enlargeButton.frame = frame;
    [enlargeButton addTarget:self action:@selector(enlargeButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
    
    //缩小按钮的代码实现
    image = [UIImage imageNamed:@"minus2-64.png"];
    shrinkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shrinkButton setBackgroundImage:image forState:UIControlStateNormal];
    //设置位置和大小
    shrinkButton.frame = CGRectMake(rect.size.width-50, rect.size.height-110, 32, 32);
    [shrinkButton addTarget:self action:@selector(shrinkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //定位按钮的代码实现
    image = [UIImage imageNamed:@"define_location-64.png"];
    locateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [locateButton setBackgroundImage:image forState:UIControlStateNormal];
    //设置位置和大小
    locateButton.frame = CGRectMake(25, rect.size.height-120, 32, 32);
    [locateButton addTarget:self action:@selector(locateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //罗盘态按钮的代码实现
    image = [UIImage imageNamed:@"compass-64.png"];
    compassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [compassButton setBackgroundImage:image forState:UIControlStateNormal];
    //设置位置和大小
    compassButton.frame = CGRectMake(rect.size.width-55, 150, 32, 32);
    [compassButton addTarget:self action:@selector(compassButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //方向地理位置编码按钮的代码实现
    image = [UIImage imageNamed:@"geo_fence-64.png"];
    getCurrentLocationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getCurrentLocationBtn setBackgroundImage:image forState:UIControlStateNormal];
    //设置位置和大小
    getCurrentLocationBtn.frame = CGRectMake(rect.size.width-55, 95, 32, 32);
    [getCurrentLocationBtn addTarget:self action:@selector(getCurrentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview: _mapView];
    [self.view addSubview:enlargeButton];
    [self.view addSubview:shrinkButton];
    [self.view addSubview:locateButton];
    [self.view addSubview:compassButton];
    [self.view addSubview:getCurrentLocationBtn];
}


-(void) enlargeButtonClicked:(id)sender
{
    if(_mapView.zoomLevel < 21)
    {
        _mapView.zoomLevel += 1;
    }
    else
    {
        _mapView.zoomLevel = 21;
    }
}

-(void)shrinkButtonClicked
{
    if(_mapView.zoomLevel > 3)
    {
        _mapView.zoomLevel -= 1;
    }
    else
    {
        _mapView.zoomLevel = 3;
    }
}

-(void)locateButtonClicked
{
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

-(void)compassButtonClicked
{
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

-(void)getCurrentButtonClicked
{
    CLLocationCoordinate2D pt = {current_Location.location.coordinate.latitude,current_Location.location.coordinate.longitude};
    BOOL flag = [_search reverseGeocode:pt];
	if (flag) {
		//NSLog(@"ReverseGeocode search success.");
        
	}
    else{
        //NSLog(@"ReverseGeocode search failed!");
    }
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
