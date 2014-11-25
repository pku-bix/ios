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
#import "detailViewController.h"
#import "RequestInfoFromServer.h"
#import "CustomBMKPointAnnotation.h"
#import "bixRemoteModelObserver.h"
#import "bixChargerDataSource.h"
#import "bixDestCharger.h"
#import "bixHomeCharger.h"
#import "bixSuperCharger.h"


@interface MapViewController()
{
    BMKAnnotationView * _annotaion;
}

@property (nonatomic) bixChargerDataSource* chargerDataSource;

@end

@implementation MapViewController
{
    RequestInfoFromServer* requestInfoFromServer;
    MapButton * mapButton;
    UIButton* enlargeButton;
    UIButton* shrinkButton;
    UIButton* locateButton;
    UIButton* compassButton;
    UIButton* getCurrentLocationBtn;
    UIImage *image;
    CGRect rect;
    int isFinishLoading, isSimpleOrDetailRequest ;
    NSInteger selectCharger;
    detailViewController *detail;
}

#pragma mark initialize

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
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mapButton = [[MapButton alloc]init];
    _search = [[BMKSearch alloc]init ];
    
    selectCharger = -1;
    
    rect = [[UIScreen mainScreen] bounds];
    GLfloat _mapY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    //  CGSize size = rect.size;   CGFloat width = size.width;  CGFloat height = size.height;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, _mapY, rect.size.width, rect.size.height-40)];

//    _mapView.delegate = self;
//    _search.delegate = self;  // 此处记得不用的时候需要置nil，否则影响内存的释放
//  [self sendRequest];
    
    
//    requestInfoFromServer = [[RequestInfoFromServer alloc]init];
//    requestInfoFromServer.selectNotificationKind = 1;
//    [requestInfoFromServer sendRequest:LOCATION_INFO_IP];
    
    self.chargerDataSource = [bixChargerDataSource defaultSource];
    self.chargerDataSource.observer = self;
    [self.chargerDataSource pullChargers];
    [self initMapViewButton];

   
    detailInfoArray = [NSMutableArray arrayWithCapacity:DETAIL_INFO_NUMBER];
    NSLog(@"end viewDidLoad");
//    [self initMapView];
    
    __block typeof(self) blockSelf = self;
    
    UzysSMMenuItem *itemClose = [[UzysSMMenuItem alloc] initWithTitle:@"取消显示" image:[UIImage imageNamed:@"close_charger_label.png"] action:^(UzysSMMenuItem *item) {
        NSLog(@"Item: %@", item);
        
        [UIView animateWithDuration:0.2 animations:^{
            blockSelf.chargerItem.frame = CGRectMake(10, 150, blockSelf.chargerItem.bounds.size.width, blockSelf.chargerItem.bounds.size.height);
        }];
        
        [self removeCharger:item.tag];
        
    }];
    
    UzysSMMenuItem *itemSuper = [[UzysSMMenuItem alloc] initWithTitle:@"超级充电桩" image:[UIImage imageNamed:@"charge_super_label.png"] action:^(UzysSMMenuItem *item) {
        NSLog(@"Item: %@", item);
        
        [UIView animateWithDuration:0.2 animations:^{
            blockSelf.chargerItem.frame = CGRectMake(10, 200, blockSelf.chargerItem.bounds.size.width, blockSelf.chargerItem.bounds.size.height);
        }];
        
        [self addSuperCharger:item.tag];

    }];
    
    UzysSMMenuItem *itemDes = [[UzysSMMenuItem alloc] initWithTitle:@"目的充电桩" image:[UIImage imageNamed:@"charge_des_label.png"] action:^(UzysSMMenuItem *item) {
        NSLog(@"Item: %@", item);
        [UIView animateWithDuration:0.2 animations:^{
            blockSelf.chargerItem.frame = CGRectMake(10, 250, blockSelf.chargerItem.bounds.size.width, blockSelf.chargerItem.bounds.size.height);
        }];
        
        [self addDestinationCHarger:item.tag];
        
    }];
    UzysSMMenuItem *itemHome = [[UzysSMMenuItem alloc] initWithTitle:@"家庭充电桩" image:[UIImage imageNamed:@"charge_home_label.png"] action:^(UzysSMMenuItem *item) {
        
        [UIView animateWithDuration:0.2 animations:^{
            blockSelf.chargerItem.frame = CGRectMake(10, 300, blockSelf.chargerItem.bounds.size.width, blockSelf.chargerItem.bounds.size.height);
        }];
        
        //[self removeAllAnnotations];  //清楚地图上所有充电桩标识@江旻
        NSLog(@"Item: %@", item);
    }];
    
    itemClose.tag = 0;
    itemSuper.tag = 1;
    itemDes.tag = 2;
    itemHome.tag = 3;
    
    //Items must contain ImageView(icon).
    self.chargerMenu = [[UzysSlideMenu alloc] initWithItems:@[itemClose,itemSuper,itemDes,itemHome]];
    self.chargerMenu.frame = CGRectMake(self.chargerMenu.frame.origin.x, 20, self.chargerMenu.frame.size.width, self.chargerMenu.frame.size.width);
    [self.view addSubview:self.chargerMenu];
}

-(void)initMapViewButton
{
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
//        int a = 5;
        NSLog(@"test");
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
//        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
//        [locationManager requestAlwaysAuthorization];
//        [locationManager requestWhenInUseAuthorization];
    }
    
    // once launch the baidu map, locate the position of user immediately
    [mapButton launchMapView_locate:_mapView];
    
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
   /*
    image = [UIImage imageNamed:@"geo_fence-64.png"];
    getCurrentLocationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getCurrentLocationBtn setBackgroundImage:image forState:UIControlStateNormal];
    //设置位置和大小
    getCurrentLocationBtn.frame = CGRectMake(rect.size.width-55, 95, 32, 32);
    [getCurrentLocationBtn addTarget:self action:@selector(getCurrentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //    self.view = _mapView;
    */
    
    [self.view addSubview: _mapView];
    [self.view addSubview:enlargeButton];
    [self.view addSubview:shrinkButton];
    [self.view addSubview:locateButton];
    [self.view addSubview:compassButton];
    [self.view addSubview:getCurrentLocationBtn];
    [self.view addSubview:superCharge];
    [self.view addSubview:destinationCharge];
    [self.view addSubview:self.chargerItem];
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

#pragma mark LifeCycle

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseResult:) name:REQUEST_SIMPLE_INFO object:nil];
    //注册获取某个具体充电桩详细信息的通知;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseDetailResult:) name:REQUEST_CHARGER_DETAIL_INFO object:nil];

   //  [_mapManager start:BAIDU_MAP_KEY  generalDelegate:self];
    NSLog(@"viewWillAppear");
    [_mapView viewWillAppear];
    _mapView.delegate = self;   //此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self;  // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil; // 不用时，置nil
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:REQUEST_SIMPLE_INFO object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:REQUEST_CHARGER_DETAIL_INFO object:nil];
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


#pragma mark Annotation

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (([annotation isKindOfClass:[CustomBMKPointAnnotation class]]) && (        [(CustomBMKPointAnnotation*)annotation type] == 0))
    {
//    (CustomBMKPointAnnotation*)annotation.type 会报错， 因为.的优先级高于(),所以在类型没转化成功时就调用了，故访问不了type这个属性;
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        newAnnotationView.annotation=annotation;
        
        newAnnotationView.image = [UIImage imageNamed:@"superCharger"];   //把大头针换成别的图片
        //标注进入界面时就处于弹出气泡框的状态
//        [newAnnotationView setSelected:YES animated:YES];
        newAnnotationView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"marker.png"]];
        
        return newAnnotationView;
    }
    else
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        //        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.annotation=annotation;

//        newAnnotationView.image = [UIImage imageNamed:@"super_charge"];   //把大头针换成别的图片
        newAnnotationView.image = [UIImage imageNamed:@"destCharger"];   //把大头针换成别的图片

        newAnnotationView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"marker.png"]]; //shcellhead.png
        
//        newAnnotationView.rightCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"marker.png"]];
//        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [selectButton setFrame:(CGRect){260,0,50,40}];
//        [selectButton setTitle:@"确定" forState:UIControlStateNormal];
//        newAnnotationView.rightCalloutAccessoryView = selectButton;
//        [selectButton setBackgroundColor:[UIColor redColor]];
        return newAnnotationView;
    }

return nil;

}


-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    if(_annotaion.annotation == view.annotation)
    {
        NSLog(@"_annotaion.annotation == view.annotation");
        return ;
    }

    if(_annotaion)
    {
        //将上次点击的annotation从地图清楚掉；
        [mapView removeAnnotation:_annotaion.annotation];
        NSLog(@"removeAnnotation");
        //再将上次点击的(即上面删除的)annotation添加到地图上面，从而使上次点击的annotation的吹出框消失；
        [mapView addAnnotation:_annotaion.annotation];
        NSLog(@"addAnnotaion");
//        _annotaion = nil;
    }
      //保存本次点击的annotation
       _annotaion = [[BMKAnnotationView alloc]initWithAnnotation:view.annotation reuseIdentifier:@"didSelectAnnotation"];
        NSLog(@"alloc _annotation");
    
}


-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"didDeselectAnnotationView");
}


//当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
//    NSLog(@" view.accessibilityValue is %@", view.reuseIdentifier);
    NSLog(@"点击annotation view弹出的泡泡, I like programming!");
    NSLog(@"%@", view.annotation.title);
    NSString *strId;
   
//    detailInfoArray = [NSMutableArray arrayWithCapacity:DETAIL_INFO_NUMBER];
    //先删除之前数组的数据，否则数据会不断累加，这是可变数组。
//    [detailInfoArray removeAllObjects];
    int k = 0;
    if ([(view.annotation.title) isEqualToString:@"我的位置"]) {
        return ;
    }
    for (int i = 0; i < chargePileNumber; i++) {
        //通过详细地址名来找到对应的id,从而构成请求的地址;
        if([[muArray objectAtIndex:k+1] isEqual:view.annotation.title])
        {
            NSLog(@"类型:%@", [muArray objectAtIndex:k]);
            NSLog(@"维度:%@", [muArray objectAtIndex:k+2]);
            strId = [NSString stringWithString:[muArray objectAtIndex:k+4]];
            NSLog(@"id is %@", strId);
            break;   //找到立刻退出循环;
        }
        k = k+5;
    }
    
    

    
//    NSMutableString *path  = [[NSMutableString alloc]initWithCapacity:60];
//    [path setString:LOCATION_DETAIL_INFO_IP];
//    [path appendString:strId];
//
//    requestInfoFromServer.selectNotificationKind = 2;
//    [requestInfoFromServer sendRequest:path];
}

-(void) modelUpdated: (id) model{
    // data arrived!
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue begin");

    if ([[segue identifier] isEqualToString:@"detail"]) {
        NSLog(@"prepareForSegue ing......");

//        [NSThread sleepForTimeInterval:1];
         detail = [segue destinationViewController];
        
    
        if (([detailInfoArray count] != 0) && ([[detailInfoArray objectAtIndex:0] isEqualToString:@"SuperCharger"])) {
            detail.type = [detailInfoArray objectAtIndex:0];
            detail.detailAddress = [detailInfoArray objectAtIndex:1];
            detail.parkingnum = [detailInfoArray objectAtIndex:2];
            detail.info = [detailInfoArray objectAtIndex:3];
        }
        else if(([detailInfoArray count] != 0) && ([[detailInfoArray objectAtIndex:0] isEqualToString:@"DestCharger"]))
        {
            detail.type = [detailInfoArray objectAtIndex:0];
            detail.detailAddress = [detailInfoArray objectAtIndex:1];
            detail.parkingnum = [detailInfoArray objectAtIndex:2];
            detail.info = [detailInfoArray objectAtIndex:3];
        }
//
        
//        NSLog(@"detail.szAddress is %@", detail.szAddress);
        NSLog(@"type is %@, detailAddress is %@, parkingnum is %@, time is %@, info is %@", detail.type, detail.detailAddress, detail.parkingnum, detail.time, detail.info);
        //detail.session = sessionToOpen;
    }
}


 #pragma mark asynchronousRequest

//解析从服务器获取的数据
-(void)parseResult:(NSNotification*)notification
{
    self.theResultData = notification.object;
    NSLog(@"get the notification data, it is ");
    NSDictionary *location = [NSJSONSerialization JSONObjectWithData:self.theResultData options:NSJSONReadingMutableLeaves error:nil];
//    NSArray *arrayResult = [location objectForKey:@"result"];
    
//    NSArray *arrayResult = [location objectForKey:@"chargers"];
    
    NSArray *arrayResult = (NSArray*)location;
    NSLog(@"数组个数是%d", [arrayResult count]);
    
    chargePileNumber = [arrayResult count];

    //muArray存储充电桩的5条信息;
    muArray = [NSMutableArray arrayWithCapacity:chargePileNumber*5];
    
    int k = 0;
    for (id obj1 in arrayResult) {
        [muArray addObject:[obj1 objectForKey:@"__t"]];
        [muArray addObject:[obj1 objectForKey:@"detailedaddress"]];
        [muArray addObject:[obj1 objectForKey:@"latitude"]];
        [muArray addObject:[obj1 objectForKey:@"longitude"]];
        [muArray addObject:[obj1 objectForKey:@"_id"]];
        k++; //for test!!
        
//        if (k%50 == 0) {
//            NSLog(@"type is %@, addr is %@",[obj1 objectForKey:@"__t"], [obj1 objectForKey:@"detailedaddress"]);
//        }
    }
    //    NSLog(@"%.8f, %.8f, %.8f, %.8f", t1, t2, t3, t4);
    //    NSRange range = [self.theResult rangeOfString:@"location"];
    //    if (range.location == NSNotFound) {
    //        NSLog(@"没找到");
    //    }
    //    else
    //    {
    //        NSLog(@"找到的范围是:%@", NSStringFromRange(range));
    //    }
}

-(void)parseDetailResult:(NSNotification*)notification
{
    self.theResultData = notification.object;
    NSDictionary *location = [NSJSONSerialization JSONObjectWithData:self.theResultData options:NSJSONReadingMutableLeaves error:nil];
//    NSArray *arrayResult = [location objectForKey:@"charger"];
    NSArray *arrayResult = (NSArray*)location;
//    NSLog(@"充电桩详情的个数是%d", [arrayResult count]);
//    NSLog(@"arrayResult is %@", arrayResult);
//    chargePileNumber = [arrayResult count];
    
//    muArray = [NSMutableArray arrayWithCapacity:chargePileNumber*5];
    [detailInfoArray removeAllObjects];
    NSLog(@"type is %@", [(id)arrayResult objectForKey:@"__t"]);
    NSLog(@"detailedaddress is %@", [(id)arrayResult objectForKey:@"detailedaddress"]);
    NSLog(@"parkingnum is %@", [(id)arrayResult objectForKey:@"parkingnum"]);
    NSLog(@"time is %@", [(id)arrayResult objectForKey:@"time"]);
    
    if ([[(id)arrayResult objectForKey:@"__t"] isEqualToString:@"SuperCharger"]) {
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"__t"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"detailedaddress"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"parkingnum"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"time"]];
    }
    else if([[(id)arrayResult objectForKey:@"__t"] isEqualToString:@"DestCharger"])
    {
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"__t"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"detailedaddress"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"parkingnum"]];
        [detailInfoArray addObject:[(id)arrayResult objectForKey:@"info"]];
    }
    
//    for (id obj in detailInfoArray) {
//        NSLog(@"%@", obj);
//    }
    
    [self performSegueWithIdentifier:@"detail" sender:self];
    
}

- (void)addSuperCharger:(NSInteger) selectTag
{
    if (selectCharger >= 0) {
        selectCharger = -1;
        NSLog(@"fuck superCharge");
        [_mapView removeAnnotations: [NSArray arrayWithArray:_mapView.annotations]];
        NSLog(@"removeAnnotations");
        int k = 0, sum = 0;
        for(int i = 0; i < chargePileNumber; i++)
        {
            
            //        BMKPointAnnotation * j = [[BMKPointAnnotation alloc]init];
            CustomBMKPointAnnotation *j = [CustomBMKPointAnnotation new];
            if([[muArray objectAtIndex:k]  isEqual: @"SuperCharger"])
            {
                sum++;
                j.coordinate = CLLocationCoordinate2DMake([[muArray objectAtIndex:k+2] doubleValue], [[muArray objectAtIndex:k+3] doubleValue]);
                j.title = [muArray objectAtIndex:k+1];
                j.type = 0; // type = 0 表示超级充电桩;
                [_mapView addAnnotation:j];
            }
            k = k+5;
        }
        NSLog(@"superCharge have %d", sum);
    }
    else
        selectCharger = selectTag;
}

- (void)addDestinationCHarger:(NSInteger)selectTag
{
    if(selectCharger >= 0){
        
        [_mapView removeAnnotations:[NSArray arrayWithArray:_mapView.annotations]];
        
        for (id key in self.chargerDataSource.chargers) {
            bixCharger* charger = self.chargerDataSource.chargers[key];
            
            if ([charger isKindOfClass:[bixDestCharger class]]) {
                CustomBMKPointAnnotation *bmk = [CustomBMKPointAnnotation new];
                bmk.coordinate = CLLocationCoordinate2DMake(charger.latitude, charger.longitude);
                bmk.title = charger.detailedAddress;
                bmk.type = 1; // type = 1; 表示目的充电桩;
                
                [_mapView addAnnotation:bmk];
            }
        }
    }
    else{
        selectCharger = selectTag;
    }
    
//    if (selectCharger >= 0) {
//        
//        NSLog(@"fuck destinationCharge");
//        
//        NSLog(@"addBatteryChargeAnnotation chargePileNumber is %d", chargePileNumber);
//        [_mapView removeAnnotations:[NSArray arrayWithArray:_mapView.annotations]];
//        NSLog(@"removeAnnotations");
//        int k = 0, sum = 0;
//        for(int i = 0; i < chargePileNumber; i++)
//        {
//            //        BMKPointAnnotation * j = [[BMKPointAnnotation alloc]init];
//            CustomBMKPointAnnotation *j = [CustomBMKPointAnnotation new];
//            if([[muArray objectAtIndex:k]  isEqual: @"DestCharger"])
//            {
//                sum++;
//                j.coordinate = CLLocationCoordinate2DMake([[muArray objectAtIndex:k+2] doubleValue], [[muArray objectAtIndex:k+3] doubleValue]);
//                j.title = [muArray objectAtIndex:k+1];
//                j.type = 1; // type = 1; 表示目的充电桩;
//                [_mapView addAnnotation:j];
//            }
//            k = k+5;
//        }
//        NSLog(@"destinationCharger have %d", sum);
//    }
//    else
//        selectCharger = selectTag;
}

- (void)removeCharger:(NSInteger)selectTag
{
    if (selectCharger >= 0) {
        [self removeAllAnnotations];
        [self.chargerMenu openIconMenu];
    }
    else
        selectCharger = selectTag;
}

-(void)removeAllAnnotations
{
    NSLog(@"清楚所有地图标注");
    [_mapView removeAnnotations:[NSArray arrayWithArray:_mapView.annotations]];
}

- (IBAction)addSuperCharge:(id)sender {
    NSLog(@"fuck superCharge");
    [_mapView removeAnnotations: [NSArray arrayWithArray:_mapView.annotations]];
    NSLog(@"removeAnnotations");
    int k = 0, sum = 0;
    for(int i = 0; i < chargePileNumber; i++)
    {

//        BMKPointAnnotation * j = [[BMKPointAnnotation alloc]init];
        CustomBMKPointAnnotation *j = [CustomBMKPointAnnotation new];
        if([[muArray objectAtIndex:k]  isEqual: @"SuperCharger"])
        {
            sum++;
            j.coordinate = CLLocationCoordinate2DMake([[muArray objectAtIndex:k+2] doubleValue], [[muArray objectAtIndex:k+3] doubleValue]);
            j.title = [muArray objectAtIndex:k+1];
            j.type = 0; // type = 0 表示超级充电桩;
            [_mapView addAnnotation:j];
        }
        k = k+5;
    }
    NSLog(@"superCharge have %d", sum);
}

- (IBAction)addDestinationCharge:(id)sender {
    NSLog(@"fuck destinationCharge");
    
    NSLog(@"addBatteryChargeAnnotation chargePileNumber is %d", chargePileNumber);
    [_mapView removeAnnotations:[NSArray arrayWithArray:_mapView.annotations]];
    NSLog(@"removeAnnotations");
    int k = 0, sum = 0;
    for(int i = 0; i < chargePileNumber; i++)
    {
//        BMKPointAnnotation * j = [[BMKPointAnnotation alloc]init];
        CustomBMKPointAnnotation *j = [CustomBMKPointAnnotation new];
        if([[muArray objectAtIndex:k]  isEqual: @"DestCharger"])
        {
            sum++;
            j.coordinate = CLLocationCoordinate2DMake([[muArray objectAtIndex:k+2] doubleValue], [[muArray objectAtIndex:k+3] doubleValue]);
            j.title = [muArray objectAtIndex:k+1];
            j.type = 1; // type = 1; 表示目的充电桩;
            [_mapView addAnnotation:j];
        }
        k = k+5;
    }
    NSLog(@"destinationCharger have %d", sum);
}

- (IBAction)chargerSelect:(id)sender {
}



@end

