//
//  MapViewController.m
//  bix
//
//  implement by dusx5
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "MapViewController.h"
#import "MapButton.h"
#import "Constants.h"

@implementation MapViewController
{
    MapButton * mapButton;
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
    
    mapButton = [[MapButton alloc]init];
    _search = [[BMKSearch alloc]init ];
    
    rect = [[UIScreen mainScreen] bounds];
    //  CGSize size = rect.size;   CGFloat width = size.width;  CGFloat height = size.height;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-40)];
    
    _mapView.delegate = self;
    
    // once launch the baidu map, locate the position of user immediately
    [mapButton launchMapView_locate:_mapView];
    [self initMapViewButton];
    [self addBatteryChargeAnnotation];
    
}

-(void)initMapViewButton
{
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
    //    self.view = _mapView;

    
    [self.view addSubview: _mapView];
    [self.view addSubview:enlargeButton];
    [self.view addSubview:shrinkButton];
    [self.view addSubview:locateButton];
    [self.view addSubview:compassButton];
    [self.view addSubview:getCurrentLocationBtn];
}

#pragma mark five_mapButton_events

-(void) enlargeButtonClicked:(id)sender
{
    [mapButton enlargeButtonClicked:_mapView];
}

-(void)shrinkButtonClicked
{
    [mapButton shrinkButtonClicked:_mapView];
}

-(void)locateButtonClicked
{
    [mapButton locateButtonClicked:_mapView];
}

-(void)compassButtonClicked
{
    [mapButton compassButtonClicked:_mapView];
}

-(void)getCurrentButtonClicked
{
    [mapButton getCurrentButtonClicked:_search current_Location:current_Location];
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
   [mapButton onGetAddrResult:result errorCode:error BMapView:_mapView];
}

-(void)viewWillAppear:(BOOL)animated
{
   //  [_mapManager start:BAIDU_MAP_KEY  generalDelegate:self];
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
    current_Location = [mapButton didUpdateUserLocation:userLocation];
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


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (([annotation isKindOfClass:[BMKPointAnnotation class]]) && [[annotation subtitle] isEqualToString :@"家庭充电桩"]){
        
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        newAnnotationView.annotation=annotation;
        
        newAnnotationView.image = [UIImage imageNamed:@"icon_nav_end.png"];   //把大头针换成别的图片
        
        return newAnnotationView;
        
    }
    else
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        
        //        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        newAnnotationView.annotation=annotation;
        
        newAnnotationView.image = [UIImage imageNamed:@"icon_nav_start.png"];   //把大头针换成别的图片
        
        return newAnnotationView;

    }
        
    return nil;
    
}


-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    NSLog(@"didSelectAnnotationView");
    
}


-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    
    NSLog(@"didDeselectAnnotationView");
}


//当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"点击annotation view弹出的泡泡, I like programming!");
//    [view setSelected:YES animated:YES];
    view.leftCalloutAccessoryView =
    //气泡框左侧显示的View,可自定义
    view.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nav_start.png"]];
}

-(void)addBatteryChargeAnnotation
{
    //添加自定义Annotation
    CLLocationCoordinate2D annotation1 = {39.8253312,116.391234};
    CLLocationCoordinate2D annotation2 = {39.81669,116.39716};
    CLLocationCoordinate2D annotation3 = {39.83669,116.39516};
    
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = annotation1;
//    item.title = @"超级充电桩1";
    
    BMKPointAnnotation* item2 = [[BMKPointAnnotation alloc]init];
    item2.coordinate = annotation2;
    item2.title = @"超级充电桩2";
    item2.subtitle = @"家庭充电桩";

    BMKPointAnnotation* item3 = [[BMKPointAnnotation alloc]init];
    item3.coordinate = annotation3;
    item3.title = @"点击获取超级充电桩详情";

    
    [_mapView addAnnotation:item];
    [_mapView addAnnotation:item2];
    [_mapView addAnnotation:item3];
    
}

@end
