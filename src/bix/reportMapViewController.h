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
    //       NSString *strLatitude, *strLongitude;
    //    IBOutlet BMKMapView *reportMap;
    
}

@property NSString *strLatitude;
@property NSString *strLongitude;

//放大
- (IBAction)zoomIn:(id)sender;
//缩小
- (IBAction)zoomOut:(id)sender;

- (IBAction)currentLocation:(id)sender;

- (IBAction)nextStep:(id)sender;
@end
