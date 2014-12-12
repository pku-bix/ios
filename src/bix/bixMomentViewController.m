//
//  bixMomentViewController.m
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//
#import "bixMomentViewController.h"
#import "bixMomentTableViewCell.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "bixCaptureViewController.h"
#import "bixSendMoodData.h"
#import "UIScrollView+MJRefresh.h"
#import "RequestInfoFromServer.h"
#import "bixMomentDataItem.h"

@interface bixMomentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation bixMomentViewController
{
    int numberOFMomentDataItem;
    UIImage *image_send_mood_data;
    NSString *newMomentText;
    BOOL isRefresh;
    RequestInfoFromServer *request;
    bixMomentDataItem *itemRefresh;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    numberOFMomentDataItem = 1;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    isRefresh = false;

    [bixMomentDataSource defaultSource].observer = self;
    [self header_footer_refreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)header_footer_refreshing
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"bix正在帮你刷新中,不客气";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"bix正在帮你加载中,不客气";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    NSLog(@"正在刷新，在这里请求服务器数据");
    [[bixMomentDataSource defaultSource] pull];
}

- (void)footerRereshing
{
    NSLog(@"正在上拉加载， 在这里请求后面的数据");
    [[bixMomentDataSource defaultSource]loadMore];
//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self.tableView footerEndRefreshing];
//    });
}

#pragma mark - TableViewSource

//一个section区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    numberOFMomentDataItem = [[bixMomentDataSource defaultSource] numberOfMomentDataItem];
    NSLog(@"bixMomentViewController.m numberOfRows is %d", [[bixMomentDataSource defaultSource]numberOfMomentDataItem]);
    return numberOFMomentDataItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bixMomentDataItem *item = [[bixMomentDataSource defaultSource]getMomentAtIndex:(indexPath.row)];
//    NSLog(@"第%d个item，momentViewController.m", (numberOFMomentDataItem-indexPath.row-1));
    
    // reuse key must be identical to that set on storyboard
    bixMomentTableViewCell *cell = (bixMomentTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"moment-item" forIndexPath:indexPath];
    
    NSLog(@"Loading Data");
    [cell loadFromMomentDataItem:item];
    //cell 被选中后颜色不变， 不会变暗！！
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
//    //点击cell的时候，不会变暗，不会有反应;
////    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 368;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select %d section, %d row", indexPath.section, indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        [self performSegueWithIdentifier:@"test" sender:self];
    }
    //选中后的反显颜色即刻消失,即选中cell后，cell的高亮立刻消失；

}

- (IBAction)sendMood:(id)sender {
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [chooseImageSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0://Take picture
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //当设备带有照相功能,则进入照相模式;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            [self presentViewController:picker animated:YES completion:nil];
            //[self presentModalViewController:picker animated:YES];  此函数ios6之后已经废弃不用！
            break;
            
        case 1://From album
            //进入设备的图片库;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;

        default:
            break;
    }
}

#pragma mark 拍照选择照片协议方法
//当进入拍照模式拍照 并且点击Use photo后 或者 从本地图库选择图片后 会调用此方法;
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSLog(@"mediaType is %@", mediaType);
    
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        //将二进制数据生成UIImage
       image_send_mood_data = [UIImage imageWithData:data];
        
        //隐藏UIImagePickerController本身的导航栏
        picker.navigationBar.hidden = YES;
        
        NSLog(@"end picker image");
        
//        [picker pushViewController:sendMoodData animated:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
//        [self presentViewController:sendMoodData animated:YES completion:nil];
        [self performSegueWithIdentifier:@"sendMood" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    bixSendMoodData * sendMood = (bixSendMoodData*)segue.destinationViewController;
    sendMood.image1 = image_send_mood_data;
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    //    UIGraphicsBeginImageContext(CGSizeMake(60, 60));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize , image.size.height * scaleSize)];
    //    [image drawInRect:CGRectMake(0, 0, 60, 60)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image
{
    UIGraphicsBeginImageContext(CGSizeMake(60, 60));
    [image drawInRect:CGRectMake(0, 0, 60 , 60)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) modelUpdated:(id)model{
    [self.tableView reloadData];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

@end
