//
//  personInfoViewController.h
//  bix
//
//  Created by dsx on 14-10-13.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSArray *list2;
@end
