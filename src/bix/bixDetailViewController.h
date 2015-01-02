//
//  detailViewController.h
//  bix
//
//  Created by dsx on 14-10-1.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bixCharger.h"

@interface bixDetailViewController : UIViewController<bixRemoteModelObserver, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) bixCharger *charger;

@property (strong, nonatomic) IBOutlet UILabel *chargerType;

@property (strong, nonatomic) IBOutlet UITextView *chargerAddress;

@property (strong, nonatomic) IBOutlet UILabel *chargerParkingnum;

@property (strong, nonatomic) IBOutlet UILabel *chargerInfo;

- (IBAction)back:(id)sender;


@end
