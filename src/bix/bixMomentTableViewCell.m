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

//作为全局的一个momentDataItem变量, 整个.m文件几个地方需要用到;
@property (nonatomic) bixMomentDataItem *momentDataItem;

@end

@implementation bixMomentTableViewCell
{
<<<<<<< HEAD
    NSString *message;
    int flag_notification;
    CGFloat mImgCollectionViewWidth;
    CGFloat mImgCollectionViewHeight;
=======
//    NSString *message;
//    int flag_notification;
>>>>>>> a01410d1dc5de5ffad9ba829926e88f92ed38815
}

// load from reuse key
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSLog(@"Init");
    }
    return self;
}

// load from nib or storyboard
-(id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // Initialization code
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _userImageView.frame = CGRectMake( MOMENT_PADDING_LEFT, MOMENT_PADDING_TOP, MOMENT_HEAD_SHOW_SIZE, MOMENT_HEAD_SHOW_SIZE);
        [self.contentView addSubview:_userImageView];
        
        _userLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userLabel.textColor = [UIColor orangeColor];
        _userLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userLabel];
        
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _contentTextView.font = [UIFont systemFontOfSize:15.0];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentTextView.textContainer.lineFragmentPadding = 0;
        [self.contentView addSubview:_contentTextView];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        _imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _imgCollectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgCollectionView];
        [self.imgCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    }
    return self;
}

//设置头像、名字昵称、发送的文字以及回复构成的一条 分享字段;
// obsolete
- (void) loadFromMomentDataItem:(bixMomentDataItem*)item {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseMoment1:) name:@"sendOneMomentDataItem" object:nil];
    NSLog(@"loading moment...\n%@",item);
    
    self.momentDataItem = item;

    NSString* displayName = item.sender.nickname;
    if (displayName == nil || [displayName isEqualToString:@""]) {
        displayName = item.sender.username;
    }
    [self.userLabel setText:displayName];
    [self.contentTextView setText:item.textContent];
    NSLog(@"replyContent %d", item.replies.count);
    [item.sender.avatar setImageToImageView:self.userImageView];
    _userImageView.frame = CGRectMake( MOMENT_PADDING_LEFT,
                                       MOMENT_PADDING_TOP,
                                       MOMENT_HEAD_SHOW_SIZE,
                                       MOMENT_HEAD_SHOW_SIZE );
    
    _userLabel.frame = CGRectMake( MOMENT_PADDING_LEFT + MOMENT_HEAD_SHOW_SIZE + MOMENT_HEAD_SHOW_RIGHT_SP,
                                   MOMENT_PADDING_TOP,
                                   [UIScreen mainScreen].currentMode.size.width/2.0 - (MOMENT_PADDING_LEFT + MOMENT_HEAD_SHOW_SIZE + MOMENT_HEAD_SHOW_RIGHT_SP + MOMENT_PADDING_RIGHT),
                                   20 );
    
    CGSize _contentTextSize = [self getDisplaySize:item.textContent];
    _contentTextView.frame = CGRectMake( MOMENT_PADDING_LEFT + MOMENT_HEAD_SHOW_SIZE + MOMENT_HEAD_SHOW_RIGHT_SP,
                                         MOMENT_PADDING_TOP + 20 + MOMENT_USER_NAME_BOTTOM_SP,
                                         [UIScreen mainScreen].currentMode.size.width/2.0 - (MOMENT_PADDING_LEFT + MOMENT_HEAD_SHOW_SIZE + MOMENT_HEAD_SHOW_RIGHT_SP + MOMENT_PADDING_RIGHT),
                                          _contentTextSize.height);
    
    mImgCollectionViewWidth = [UIScreen mainScreen].currentMode.size.width/2.0 - (MOMENT_PADDING_LEFT + MOMENT_HEAD_SHOW_SIZE + MOMENT_HEAD_SHOW_RIGHT_SP + MOMENT_PADDING_RIGHT);
    mImgCollectionViewHeight = ((mImgCollectionViewWidth - 20.0)/3 + 10.0) * ceil(item.imageProxyArray.count/3.0);
    _imgCollectionView.frame = CGRectMake( MOMENT_PADDING_LEFT + MOMENT_HEAD_SHOW_SIZE + MOMENT_HEAD_SHOW_RIGHT_SP,
                                           MOMENT_PADDING_TOP + 20 + MOMENT_USER_NAME_BOTTOM_SP + _contentTextView.frame.size.height + MOMENT_TEXT_CONTENT_BOTTOM_SP,
                                           mImgCollectionViewWidth,
                                           mImgCollectionViewHeight);
    
    self.imgCollectionView.delegate = self;
    self.imgCollectionView.dataSource = self;
    [self.imgCollectionView reloadData];

    self.replyTableView.delegate   = self;
    self.replyTableView.dataSource = self;
    [self.replyTableView reloadData];
}

-(CGSize) getDisplaySize:(NSString*) str{
    
    CGSize textSize = {[UIScreen mainScreen].currentMode.size.width/2.0 - (MOMENT_PADDING_LEFT + MOMENT_HEAD_SHOW_SIZE + MOMENT_HEAD_SHOW_RIGHT_SP + MOMENT_PADDING_RIGHT),   INTMAX_MAX};
    
    CGSize size = [str boundingRectWithSize:textSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                    context: nil].size;
    return size;
}

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


#pragma mark - imgCollectionView dataSource

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell"
                                              forIndexPath:indexPath];
 
//    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:111];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (mImgCollectionViewWidth - 20)/3, (mImgCollectionViewWidth - 20)/3)];
    [cell.contentView addSubview:imageView];
    
    bixImageProxy* ip = self.momentDataItem.imageProxyArray[indexPath.row];
    [ip setImageToImageView:imageView];
//    NSLog(@"bixMomentTableViewCell.m self.momentDataItem.uiImageData count is %d", [self.momentDataItem.uiImageData count]);
    NSLog(@"indexPath.row is %d",indexPath.row);
//    imageView.image = [self.momentDataItem.uiImageData objectAtIndex:indexPath.row];
//    imageView.image = [UIImage imageWithData:self.momentDataItem.imgUrls[indexPath.row]];

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((mImgCollectionViewWidth - 20)/3, (mImgCollectionViewWidth - 20)/3);
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"imageProxyArray count is %d",self.momentDataItem.imageProxyArray.count);
    return self.momentDataItem.imageProxyArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - imgCollectionView delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select collectionView is section %d, row %d", indexPath.section, indexPath.row);
}


@end
