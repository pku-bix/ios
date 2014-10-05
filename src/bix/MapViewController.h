//
//  MapViewController.h
//  bix
//
//  implement by dusx5
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate,NSURLConnectionDataDelegate>
{    
    IBOutlet BMKMapView *_mapView;
    BMKSearch *_search;
    BMKUserLocation *current_Location;
    NSArray* array;
    int chargePileNumber;
    NSMutableArray *muArray, *detailInfoArray;

    IBOutlet UIButton *destinationCharge;
    IBOutlet UIButton *superCharge;
}
- (IBAction)addSuperCharge:(id)sender;
- (IBAction)addDestinationCharge:(id)sender;

@property (retain, nonatomic) NSMutableString *theResult;
@property (retain, nonatomic) NSMutableData  *theResultData;

-(void)addBatteryChargeAnnotation;

-(void)sendRequest;
-(void)parseResult;
@end
