//
//  bixViewController.m
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

@interface bixMomentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end



@implementation bixMomentViewController
{
    int numberOFMomentCell;
    UIImage *image_send_mood_data;
    NSString *newMomentText;
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
    numberOFMomentCell = 1;
    
    self.momentText = [NSMutableArray arrayWithCapacity:numberOFMomentCell];
    [self.momentText addObject:@"这是分享圈的第一条信息"];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    newMomentText = @"这是分享圈的第一条信息";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseMoment2:) name:@"sendOneMomentDataItem" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseMoment:) name:@"sendOneMomentDataItem" object:nil];
    [ self.tableView reloadData ];
}

-(void)parseMoment2:(NSNotification*)notification
{
    NSLog(@"发送了一条新的状态，心情");
    numberOFMomentCell++; //多一条 状态说说;
    NSLog(@"bixViewController.m  moment number is %d", numberOFMomentCell);
    NSLog(@"the text send from bixSendMoodData.m is %@", notification.object);
    newMomentText = notification.object;
    
    [self.momentText addObject:notification.object];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewSource

//一个section区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return numberOFMomentCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    bixMomentTableViewCell *cell = (bixMomentTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:REUSE_CELLID_MOMENTLIST];
    
    // Configure Cell
    AppDelegate* appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSUInteger row = [indexPath row];
    NSLog(@"row is %d", row);

    [cell loadFromMomentDataItem:[appdelegate.momentDataSrouce getOneMoment:[self.momentText objectAtIndex:(self.momentText.count-row-1)]]];
//    [cell loadFromMomentDataItem:[appdelegate.momentDataSrouce getOneMoment]];
    
    //点击cell的时候，不会变暗，不会有反应;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)sendMood:(id)sender {
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [chooseImageSheet showInView:self.view];
    
//    [self performSegueWithIdentifier:@"sendMood" sender:self];
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
        
//        bixSendMoodData *sendMoodData = [[bixSendMoodData alloc]init];
//        sendMoodData.delegate = self;
//        sendMoodData.image = image;
        //将图片传递给截取界面进行截取并设置回调方法（协议）
//        bixCaptureViewController *captureView = [[bixCaptureViewController alloc] init];
//        captureView.delegate = self;
//        captureView.image = image;
        
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


//
//#pragma mark - 图片回传协议方法
//-(void)passImage:(UIImage *)image
//{
//    imageView.image = image;
//    //设置头像缩放成 60*60 的
//    headImage = [self scaleFromImage:image];
//    
//    //上传头像 数据到服务器, PNG格式;
//    request = [[RequestInfoFromServer alloc]init];
//    [request sendAsynchronousPostImageRequest:headImage];
//    
//    //保存裁剪后的头像;
//    Account * accout = [appDelegate account];
//    accout.getHeadImage = headImage;
//    [accout save];
//}

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



@end
