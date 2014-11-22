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

// 分享列表Cell的控制器
// 用以控制分享列表Cell的所有子视图，并实现图片组和回复列表的数据源与事件代理。
// 如果子视图变得复杂，可以考虑分离出去。
@interface bixMomentTableViewCell()


// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
// 用户显示名
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
// 分享文本内容
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
// 分享图片组
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;
// 回复列表
@property (weak, nonatomic) IBOutlet UITableView *replyTableView;

//作为全局的一个momentDataItem变量, 整个.m文件几个地方需要用到;
@property (nonatomic) bixMomentDataItem *momentDataItem;

@end

@implementation bixMomentTableViewCell
{
    NSString *message;
    int flag_notification;
}

// load from reuse key
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// load from nib or storyboard
-(id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // Initialization code
    }
    return self;
}

//设置头像、名字昵称、发送的文字以及回复构成的一条 分享字段;
// obsolete
- (void) loadFromMomentDataItem:(bixMomentDataItem*)item {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseMoment1:) name:@"sendOneMomentDataItem" object:nil];
    NSLog(@"loading moment...\n%@",item);
    
    self.momentDataItem = item;
    
    //UILabel *label = (UILabel *)[self.contentView viewWithTag:10];
    [self.userLabel setText:item.nickname];
    
    //UITextView *text = (UITextView*)[self.contentView viewWithTag:20];

    [self.contentTextView setText:item.textContent];

    //UIImageView *avatar = (UIImageView*)[self.contentView viewWithTag:30];
    //item.avatarUrl 是NSURL类型， 不是ImageData类型
    [self.userImageView sd_setImageWithURL:item.avatarUrl];
    
    //UITableView *replies = (UITableView*)[self.contentView viewWithTag:40];
    
    self.imgCollectionView.dataSource = self;
    self.imgCollectionView.delegate = self;
    [self.imgCollectionView reloadData];
    
    self.replyTableView.dataSource = self;
    self.replyTableView.delegate   = self;
    [self.replyTableView reloadData];
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



#pragma mark - replyTableView
// 回复列表数据提供者
// 未设计回复列表Cell的Controller类，但我们可以通过tag获得子视图

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
    [text setText: [NSString stringWithFormat:@"%@ 评论:%@", reply.nickname, reply.text]];
   
    //cell 被选中后颜色不变， 不会变暗！！
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - imgCollectionView

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moment-image"
                                              forIndexPath:indexPath];

    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:111];
//    [imageView sd_setImageWithURL:self.momentDataItem.imgUrls[indexPath.row]];
    NSLog(@"bixMomentTableViewCell.m self.momentDataItem.uiImageData count is %d", [self.momentDataItem.uiImageData count]);
    NSLog(@"indexPath.row is %d",indexPath.row);
    imageView.image = [self.momentDataItem.uiImageData objectAtIndex:indexPath.row];
//    imageView.image = [UIImage imageWithData:self.momentDataItem.imgUrls[indexPath.row]];

    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSLog(@"")
    return self.momentDataItem.uiImageData.count;
}

@end
