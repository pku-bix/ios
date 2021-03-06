//
//  generalTableView.m
//  bix
//
//  Created by dsx on 14-8-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "generalTableView.h"
#import "aboutViewController.h"
#import "FeedBackViewController.h"
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation generalTableView
@synthesize list1 = _list1;
@synthesize list2 = _list2;
@synthesize list3 = _list3;

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
        return [self.list1 count];
    }
    else if(section == 1)
    {
        return [self.list2 count];
    }
    else
    {
        return [self.list3 count];
    }

}

//3个 区域;
-(NSInteger)numberOfSectionsInTableView
{
    return 3;
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

    ////    cell.detailTextLabel.text = @"i am tian cai";
//    UIImage *image0 = [UIImage imageNamed:@"personInfo"];

// 用头像url字符串直接设置uiimageview
//    UIImage *image0 = [bixLocalAccount instance].avatar;
    UIImage *image1 = [UIImage imageNamed:@"reported"];
    UIImage *image2 = [UIImage imageNamed:@"feedback"];
//    UIImage *image3 = [UIImage imageNamed:@"inviteFriends"];
    UIImage *image4 = [UIImage imageNamed:@"aboutBix"];
    UIImage *image5 = [UIImage imageNamed:@"supportUs"];
    UIImage *image6 = [UIImage imageNamed:@"logout"];

    //  cell.showsReorderControl = YES;
    NSUInteger row = [indexPath row];
    // NSUInteger section = [indexPath section];
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [self.list1 objectAtIndex:row];
        //图片显示在cell的左边， 不同cell， 显示的图片不同；
        
        switch (row) {
            case 0:
            {
                bixLocalAccount *account = [bixLocalAccount instance];
                CGRect frame = CGRectMake(0.0,0.0,60,60);
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                imageView.image = account.avatarImage;
                cell.accessoryView = imageView;
            }

//                if (image0 == NULL) {  //初始化头像
//                    NSLog(@"image0 is null");
//                    image0 = [UIImage imageNamed:@"default_headshow.png"];
                //                }
                //                cell.detailTextLabel.text= @"     dsx";
                
//                [cell.imageView sd_setImageWithURL:
//                 [NSURL URLWithString: [bixLocalAccount instance].avatar]
//                                  placeholderImage:[UIImage imageNamed:@"default_headshow.png"]];
                break;
            default:
                break;
        }

    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = [self.list2 objectAtIndex:row];
        
        switch (row) {
            case 0:
                cell.imageView.image = image1;
                break;
            case 1:
                cell.imageView.image = image2;
                //设置tableview cell 的背景颜色；
                //  cell.contentView.backgroundColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.1 alpha:1];
                break;
                
            default:
                break;
        }
    }
    else
    {
        cell.textLabel.text = [self.list3 objectAtIndex:row];
        switch (row) {
            case 0:
                cell.imageView.image = image4;
                break;
            case 1:
                cell.imageView.image = image5;
                break;
            case 2:
                cell.imageView.image = image6;
                break;
                
            default:
                break;
        }
    }
    //在cell每行右边显示的风格
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    //    四种UITableViewCellAccessoryType:
    //    UITableViewCellAccessoryNone,
    //    UITableViewCellAccessoryDisclosureIndicator,
    //    UITableViewCellAccessoryDetailDisclosureButton,
    //    UITableViewCellAccessoryCheckmark,
    //    UITableViewCellAccessoryDetailButton
    
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


-(NSString*)titleForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return @"页眉1";
    }
    else if(section == 2)
    {
        return @"页眉2";
    }
    else
        return @"";
}

-(NSString*)titleForFooterInSection:(NSInteger)section
{
    if(section == 1)
    {
        return @"页脚1";
    }
    else if(section == 2)
    {
        return @"页脚2";
    }
    else
        return @"";
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        return 78;
    }
    else
        return tableView.rowHeight;
    
}


#pragma mark delegate

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath setingViewController:(SettingViewController*)setingViewController;
{
    NSLog(@"你选中了第%d section 第 %d row", [indexPath section], indexPath.row);
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [setingViewController performSegueWithIdentifier:@"personInfo" sender:self];
        }
    }
    else if(indexPath.section == 1)
    {
        //上报充电桩
        if (indexPath.row == 0)
        {
            [setingViewController performSegueWithIdentifier:@"reportMap" sender:self];
        }
        //反馈与建议
        else if(indexPath.row == 1)
        {
            //            FeedBackViewController *feedBack = [[FeedBackViewController alloc]init];
            //            [setingViewController.navigationController pushViewController:feedBack animated:YES];
            [setingViewController performSegueWithIdentifier:@"feedBack" sender:self];
        }
//        else if(indexPath.row == 3)
//        {
//            //  UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的section和行信息" message:rowString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            //        // NSLog(sectionNumber);
//            //        [alter show];
//            
//        }
    }
    else  //section = 1;
    {
        if(indexPath.row == 0)
        {
//            aboutViewController * about = [[aboutViewController alloc]init];
//             //self => setingViewController
//            [setingViewController.navigationController pushViewController:about animated:YES];
//            about.title = @"关于";
            [setingViewController performSegueWithIdentifier:@"aboutBix" sender:self];
        }
        else if(indexPath.row == 2)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确认"
                                                            message:@"是否退出当前账号？"
                                                           delegate:setingViewController  //self => setingViewController
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}


@end
