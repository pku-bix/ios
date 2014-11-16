//
//  bixMomentTableViewCell.m
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//

#import "bixMomentTableViewCell.h"
#import "bixMomentDataItem.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Constants.h"
#import "bixMomentReplyItem.h"

@interface bixMomentTableViewCell()

@property (nonatomic) bixMomentDataItem *momentDataItem;

@end

@implementation bixMomentTableViewCell
{
    NSString *message;
    int flag_notification;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    self.momentText = [NSMutableArray arrayWithCapacity:1];
    
    [self.momentText addObject:@"这是第一条分享圈的消息"];

    flag_notification = 0;
    return self;
}

//设置头像、名字昵称、发送的文字以及回复构成的一条 分享字段;
- (void) loadFromMomentDataItem:(bixMomentDataItem*)item {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseMoment1:) name:@"sendOneMomentDataItem" object:nil];
    NSLog(@"loading moment...\n%@",item);
    
    self.momentDataItem = item;
    
    UILabel *label = (UILabel *)[self.contentView viewWithTag:10];
    [label setText:item.nickname];
    
    UITextView *text = (UITextView*)[self.contentView viewWithTag:20];

        [text setText:item.passage];


    
    UIImageView *avatar = (UIImageView*)[self.contentView viewWithTag:30];
    [avatar sd_setImageWithURL:item.avatarUrl];
    
    UITableView *replies = (UITableView*)[self.contentView viewWithTag:40];
    replies.dataSource = self;
    replies.delegate   = self;
}
//
//-(void)parseMoment1:(NSNotification*)notification
//{
//    NSLog(@"bixMomentTableViewCell.h notification");
//    message = notification.object;
//    flag_notification = 1; //表明有通知发送出来
//    [self.momentText addObject:message];
//    NSLog(@"message is %@", message);
//    
//}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - TableViewSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.momentDataItem.replies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:REUSE_CELLID_MOMENTREPLYLIST];
    
    // Configure Cell
    bixMomentReplyItem* reply = [self.momentDataItem.replies objectAtIndex: indexPath.row];
    
    UIImageView *avatar = (UIImageView*)[cell.contentView viewWithTag:41];
    [avatar sd_setImageWithURL:reply.avatarUrl];
    
    UITextView *text = (UITextView*)[cell.contentView viewWithTag:42];
    [text setText: [NSString stringWithFormat:@"%@ 回复：%@", reply.nickname, reply.text]];
   
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
