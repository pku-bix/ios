//
//  reportMapViewController.m
//  bix
//
//  Created by dsx on 14-10-21.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "reportMapViewController.h"
#import "Constants.h"
#import "UIButton+Bootstrap.h"
#import "chargerInfoViewController.h"


@interface reportMapViewController ()

@end

@implementation reportMapViewController
{
    CGRect rect;
    BMKPointAnnotation* item_Annotation ;
    UIImage *image;
    NSDictionary *coordinateDic;
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
    NSLog(@"reportMapView viewDidLoad");
    // Do any additional setup after loading the view.
    rect = [[UIScreen mainScreen]bounds];
    
    //reportMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, rect.size.width, rect.size.height)];
    //
    _search = [[BMKSearch alloc]init ];
    item_Annotation = [[BMKPointAnnotation alloc]init];
    
    self.tabBarController.tabBar.hidden=YES;
    
//    [reportMapView addSubview:btnShrink];
    
    image= [UIImage imageNamed:@"plus2-64.png"];
     btnMagnify= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnMagnify setBackgroundImage:image forState:UIControlStateNormal];
    //    设置和大小
    CGRect frame = CGRectMake(rect.size.width-50, rect.size.height-200, 32, 32);
    //    将frame的位置大小复制给Button
    btnMagnify.frame = frame;
    [btnMagnify addTarget:self action:@selector(zoomInReport) forControlEvents:UIControlEventTouchUpInside];
    
    btnShrink = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShrink setBackgroundImage:[UIImage imageNamed:@"minus2-64.png"] forState:UIControlStateNormal];
    CGRect shrinkFrame = CGRectMake(rect.size.width-50, rect.size.height-150, 32, 32);
    btnShrink.frame = shrinkFrame;
    [btnShrink addTarget:self action:@selector(zoomOutReport) forControlEvents:UIControlEventTouchUpInside];
    
    btnCurrentLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"charge_home_label.png"] forState:UIControlStateNormal];
    CGRect locationFrame = CGRectMake(rect.size.width-50, rect.size.height-350, 32, 32);
    btnCurrentLocation.frame = locationFrame;
    [btnCurrentLocation addTarget:self action:@selector(currentLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:reportMapView];
 //   [self.view addSubview:btnReportCharger];
 //   [self.view addSubview:btnCurrentLocation];
    [self.view addSubview:btnMagnify];
    [self.view addSubview:btnShrink];
    [self.view addSubview:btnCurrentLocation];
//    [self.view addSubview:btnShrink];
    
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseAgain:) name:@"chargerInfoViewController" object:nil];
    //    [self getCurrentButtonClicked:_search current_Location:current_Location];
}

// 得知 chargerInfoViewController注册了通知， 此时再发通知，通知得先注册，再post发送，观察者才能收到;
////即chargerInfoViewController得先注册通知， reportMapViewController再发送通知，chargerInfoViewController才能收到通知，
//-(void)parseAgain:(NSNotification*)notification
//{
//    NSLog(@"返回来发送通知");
//    coordinateDic = [NSDictionary dictionaryWithObjectsAndKeys:_strLatitude, @"latitude", _strLongitude, @"longitude", nil];
////    NSString *noti = @"test the problem signature";
////    [[NSNotificationCenter defaultCenter]postNotificationName:SEND_COORDINATE object:strLatitude];
//     [[NSNotificationCenter defaultCenter]postNotificationName:SEND_COORDINATE object:nil userInfo:coordinateDic];
//}

-(void)locateCurrentPosition
{
    reportMapView.showsUserLocation = NO;
    reportMapView.userTrackingMode = BMKUserTrackingModeFollow;
    reportMapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    NSLog(@"reportMap viewWillAppear");
    [reportMapView viewWillAppear];
    reportMapView.delegate = self;
    _search.delegate = self;
    [self locateCurrentPosition];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"reportMapView viewWillDisappear");
    self.tabBarController.tabBar.hidden=NO;
    [reportMapView viewWillDisappear];
    reportMapView.delegate = nil;
    _search.delegate = nil;
    reportMapView.showsUserLocation = NO;
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


- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    if (error == 0) {
        //		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        //        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorGreen;
		item_Annotation.coordinate = result.geoPt;
        //		item_Annotation.title = result.strAddr ;
        
        item_Annotation.title = @"大头针可拖动";
        item_Annotation.subtitle = @"拖动大头针到上报位置";
        [reportMapView addAnnotation:item_Annotation];
        _strLatitude = [NSString stringWithFormat:@"%f", result.geoPt.latitude];
        _strLongitude = [NSString stringWithFormat:@"%f", result.geoPt.longitude ];
        NSLog(@"按下 当前位置 按钮时 的纬度:%@, 经度:%@", _strLatitude, _strLongitude);
        //        current_Location = (BMKUserLocation)result.geoPt;
        //        [item setCoordinate:result.geoPt];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 // */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation");
    if (userLocation != nil) {
        //		NSLog(@"维度是:%f 经度是:%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	}
    current_Location = userLocation;
    
    //    item_Annotation setCoordinate:
    //    [reportMapView removeAnnotation:item];
    //    [reportMapView removeAnnotations:reportMapView.annotations];
    //    [self getCurrentButtonClicked:_search current_Location:current_Location];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)zoomOutReport{
    if(reportMapView.zoomLevel > 3)
    {
        reportMapView.zoomLevel -= 1;
    }
    else
    {
        reportMapView.zoomLevel = 3;
    }
    
}

- (void)zoomInReport{
    
    if(reportMapView.zoomLevel < 21)
    {
        reportMapView.zoomLevel += 1;
    }
    else
    {
        reportMapView.zoomLevel = 21;
    }

}

- (void)currentLocation {
    [self getCurrentButtonClicked:_search current_Location:current_Location];
}

- (IBAction)nextStep:(id)sender {
    [self performSegueWithIdentifier:@"report" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender{
    chargerInfoViewController *c = (chargerInfoViewController*)segue.destinationViewController;
    c.latitude = self.strLatitude;
    c.longitude = self.strLongitude;
}


//-(IBAction)onClickReverseGeocode
//{
////    isGeoSearch = false;
//	CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
////	if (_coordinateXText.text != nil && _coordinateYText.text != nil) {
////		pt = (CLLocationCoordinate2D){[_coordinateYText.text floatValue], [_coordinateXText.text floatValue]};
////	}
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
////    [reverseGeocodeSearchOption release];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
//
//}
//
//-(void)getCurrentAddr
//{
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[strLatitude doubleValue], [strLongitude doubleValue]};
//}
//

/*
 enum {
 BMKAnnotationViewDragStateNone = 0,      ///< 静止状态.
 BMKAnnotationViewDragStateStarting,      ///< 开始拖动
 BMKAnnotationViewDragStateDragging,      ///< 拖动中
 BMKAnnotationViewDragStateCanceling,     ///< 取消拖动
 BMKAnnotationViewDragStateEnding         ///< 拖动结束
 };
 */

-(void)mapView:(BMKMapView*)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState
{
    switch (newState) {
        case BMKAnnotationViewDragStateNone:
            NSLog(@"静止时的坐标是:%f, %f", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
        case BMKAnnotationViewDragStateStarting:
            NSLog(@"提起时的坐标是:%f, %f", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
            break;
        case BMKAnnotationViewDragStateEnding:
        {
            NSLog(@"放下时的坐标是:%f, %f", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
            _strLatitude = [NSString stringWithFormat:@"%f", view.annotation.coordinate.latitude ];
            _strLongitude = [NSString stringWithFormat:@"%f", view.annotation.coordinate.longitude];
        }
            break;
            
        default:
            break;
    }
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    NSLog(@"坐标是:%f, %f", newCoordinate.latitude, newCoordinate.longitude);
    //    NSLog(@"新的坐标是: %f", newCoordinate);
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        //        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.annotation=annotation;
        //            [newAnnotationView setSelected:YES animated:YES];
        newAnnotationView.draggable = YES;
        //            NSLog(@"维度: %@, 经度:", item_Annotation.coordinate);
        //            current_Location = newAnnotationView.annotation;
        return newAnnotationView;
    }
    return nil;
}


- (IBAction)backSettingView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
