//
//  reportMapViewController.h
//  bix
//
//  Created by dsx on 14-10-21.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface reportMapViewController : UIViewController<BMKMapViewDelegate, BMKSearchDelegate>
{
    //    BMKMapView * reportMapView;
    
    IBOutlet UIButton *btnReportCharger;
    IBOutlet BMKMapView *reportMapView;
    
    IBOutlet UIButton *btnShrink;
    IBOutlet UIButton *btnMagnify;
    
    IBOutlet UIButton *btnCurrentLocation;
    BMKSearch *_search;
    BMKUserLocation *current_Location;
    
    
    __weak IBOutlet UIButton *btnEnlarge;
    
    //       NSString *strLatitude, *strLongitude;
    //    IBOutlet BMKMapView *reportMap;
}

- (IBAction)backSettingView:(id)sender;

@property NSString *strLatitude;
@property NSString *strLongitude;

//放大
- (void)zoomInReport;
//缩小
- (void)zoomOutReport;

- (void)currentLocation;

- (IBAction)nextStep:(id)sender;
@end
