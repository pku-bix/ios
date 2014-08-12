//
//  generalTableView.m
//  bix
//
//  Created by dsx on 14-8-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "generalTableView.h"
#import "aboutViewController.h"

@implementation generalTableView
@synthesize list = _list;
@synthesize list2 = _list2;

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

#pragma mark dataSource

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [self.list count];
    }
    else
    {
        return [self.list2 count];
    }

}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault  //cell的风格会决定下面cell.detailTextLabel.text是否有效，以及效果是怎么样的。
                reuseIdentifier:TableSampleIdentifier];
    }
    //  cell.showsReorderControl = YES;
    NSUInteger row = [indexPath row];
    // NSUInteger section = [indexPath section];
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [self.list objectAtIndex:row];
    }
    else
    {
        cell.textLabel.text = [self.list2 objectAtIndex:row];
    }
    //在cell每行右边显示的风格
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    //    四种UITableViewCellAccessoryType:
    //    UITableViewCellAccessoryNone,
    //    UITableViewCellAccessoryDisclosureIndicator,
    //    UITableViewCellAccessoryDetailDisclosureButton,
    //    UITableViewCellAccessoryCheckmark,
    //    UITableViewCellAccessoryDetailButton
    
    ////    cell.detailTextLabel.text = @"i am tian cai";
    UIImage *image0 = [UIImage imageNamed:@"personInfo"];
    UIImage *image1 = [UIImage imageNamed:@"share"];
    UIImage *image2 = [UIImage imageNamed:@"reported"];
    UIImage *image3 = [UIImage imageNamed:@"invite"];
    //图片显示在cell的左边， 不同cell， 显示的图片不同；
    
    switch (row) {
        case 0:
            cell.imageView.image = image0;
            break;
        case 1:
            cell.imageView.image = image1;
            //设置tableview cell 的背景颜色；
            //  cell.contentView.backgroundColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.1 alpha:1];
            break;
        case 2:
            cell.imageView.image = image2;
            break;
        case 3:
            cell.imageView.image = image3;
            break;
            
        default:
            break;
    }
    //    UIImage *highLighedImage = [UIImage imageNamed:@"geo_fence-32"];
    //    cell.imageView.highlightedImage = highLighedImage;
    //    cell.detailTextLabel.text = @"asdfasdf";
    
    //cell 被选中后颜色不变， 不会变暗！！
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    typedef enum : NSInteger {
    //        UITableViewCellSelectionStyleNone,
    //        UITableViewCellSelectionStyleBlue,
    //        UITableViewCellSelectionStyleGray,
    //        UITableViewCellSelectionStyleDefault
    //    } UITableViewCellSelectionStyle;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView
{
    return 2;
}

-(NSString*)titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"页眉0";
    }
    else
    {
        return @"页眉1";
    }
}

-(NSString*)titleForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"页脚0";
    }
    else
    {
        return @"页脚1";
    }
}

#pragma mark delegate

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
