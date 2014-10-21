//
//  reportMapViewController.h
//  bix
//
//  Created by dsx on 14-10-21.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface reportMapViewController : UIViewController<BMKMapViewDelegate>
{
//    BMKMapView * reportMapView;
    
    IBOutlet UIButton *btnReportCharger;
    IBOutlet BMKMapView *reportMapView;
//    IBOutlet BMKMapView *reportMap;
    
}

- (IBAction)nextStep:(id)sender;
@end
