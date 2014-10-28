//
//  bixMomentTableViewCell.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bixMomentDataItem.h"

@interface bixMomentTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

- (void) loadFromMomentDataItem:(bixMomentDataItem*)item;

@end
