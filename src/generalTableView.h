//
//  generalTableView.h
//  bix
//
//  Created by dsx on 14-8-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingViewController.h"

@interface generalTableView : NSObject
{
    SettingViewController * settingViewController;
}

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSArray *list2;

-(id)init;
//-(id)initWithSettingViewController:(SettingViewController*)settingViewController;

//dataSource
-(NSInteger)numberOfSectionsInTableView;
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSString*)titleForHeaderInSection:(NSInteger)Section;
-(NSString*)titleForFooterInSection:(NSInteger)section;


//delegate
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath setingViewController:(SettingViewController*)setingViewController;
//-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
