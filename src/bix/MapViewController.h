//
//  MapViewController.h
//  bix
//
//  implement by dusx5
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate>
{
    
    
    IBOutlet BMKMapView *_mapView;
    /* storyboard实现的按钮。
    IBOutlet UIButton *followingBtn;
    IBOutlet UIButton *compass;
    IBOutlet UIButton *magnifyBtn;
    IBOutlet UIButton *lessen;
    IBOutlet UIButton *shareBtn;
    */
    
    BMKSearch *_search;
    BMKUserLocation *current_Location;
    NSArray* array;
}
/*storyboard实现的按钮 触发函数

- (IBAction)startFollow:(id)sender;
- (IBAction)compassHeading:(id)sender;
- (IBAction)getReverseGeoAddress:(id)sender;
- (IBAction)enLarge:(id)sender;
- (IBAction)zoomOut:(id)sender;
*/
@end
