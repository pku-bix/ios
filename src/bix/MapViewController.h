//
//  MapViewController.h
//  bix
//
//  Created by harttle on 14-3-6.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapViewController : UIViewController<BMKMapViewDelegate>
{
    BMKSearch *_search;
    BMKUserLocation *current_Location;
    
    IBOutlet BMKMapView *_mapView;
    
    IBOutlet UIButton *followingBtn;
    
    IBOutlet UIButton *compass;
}
- (IBAction)startFollow:(id)sender;

- (IBAction)compassHeading:(id)sender;

- (IBAction)getReverseGeoAddress:(id)sender;

@end
