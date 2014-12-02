//
//  personInfoViewController.m
//  bix
//
//  Created by dsx on 14-10-13.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "personInfoViewController.h"
#import "bixCaptureViewController.h"
#import "generalTableView.h"
#import "AppDelegate.h"
#import "RequestInfoFromServer.h"
#import "MessageBox.h"
#import "MBProgressHUD.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface personInfoViewController ()

@end

@implementation personInfoViewController
{
    //个人信息页面的5个字段;
    NSString * name;
    NSString* signature;
    NSString* ID;
    NSString* WechatID;
    NSString* TeslaType;
    
    UIImageView *imageView;
    UIImage * headImage;
    
    CGRect rect;
    UITableView *_tableView;
    AppDelegate* appDelegate;
    RequestInfoFromServer* request;
    
    MBProgressHUD *hud;
    
    //    generalTableView *personInfo_generalTableView;
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
    NSLog(@"personInfoViewController.h viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    bixLocalAccount* account = [bixLocalAccount instance];
    
    //加载之前保存的名字字段;
    name = account.nickname;
    signature = account.signature;
    ID = account.username;
    WechatID = account.wechatID;
    TeslaType = account.teslaType;

    //这些通知 只要注册一次就可以了
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getName:) name:@"nameChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSignature:) name:@"signatureChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getID:) name:@"IDChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWechatID:) name:@"WechatID" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTeslaType:) name:@"TeslaType" object:nil];
    
    //加载之前保存的头像；
//    [imageView sd_setImageWithURL: [NSURL URLWithString: account.avatar]];
    
    NSLog(@"headImage is ...  %@", headImage);
    
    if (headImage == NULL) {
        headImage = [UIImage imageNamed:@"default_headshow.png"];
    }
    
    NSLog(@"last name is %@", name);
    
    rect = [[UIScreen mainScreen]bounds];
    
    //    personInfo_generalTableView = [[generalTableView alloc]init];
    
    NSArray * array = [[NSArray alloc]initWithObjects:@"头像", @"名字",@"个性签名", nil];
    NSArray * array2 = [[NSArray alloc]initWithObjects:@"个人ID", @"微信号", @"Tesla车型", nil];
    
    self.list = array;
    self.list2 = array2;
    
    //用代码来创建 tableview, tableview的高度需要设置成rect.size.height-navigationbar的高度，才不会出现滚动到最下面的行又自动滚动回前面。
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-50) style:UITableViewStyleGrouped];
    //    table_View.contentSize = CGSizeMake(320, 2000);
    //设置tableview的背景；
    //    UIImageView *tableBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tesla"]];
    //    [_tableView setBackgroundView:tableBg];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"personInfoViewController will appear");
    
    //设置 dataSource 和 delegate 这两个代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

-(void)getName:(NSNotification*)notification
{
    name = notification.object;
    NSLog(@"name from notification is %@", name);
}

-(void)getSignature:(NSNotification*)notification
{
    signature = notification.object;
    NSLog(@"signature from notification is %@",signature);
}

-(void)getID:(NSNotification*)notification
{
    ID = notification.object;
    NSLog(@"ID from notification is %@",ID);
}

-(void)getWechatID:(NSNotification*)notification
{
    WechatID = notification.object;
    NSLog(@"weChatID from notification is %@",WechatID);
}

-(void)getTeslaType:(NSNotification*)notification
{
    TeslaType = notification.object;
    NSLog(@"teslaType from notification is %@",TeslaType);
}


- (void)viewWillDisappear:(BOOL)animated{

//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nameChange" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"signatureChange" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"IDChange" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WechatID" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TeslaType" object:nil];
    //不用时，置nil
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}


#pragma mark dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.list count];
    }
    else
    {
        return [self.list2 count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return [general_TableView tableView:tableView cellForRowAtIndexPath:indexPath];
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1  //cell的风格会决定下面cell.detailTextLabel.text是否有效，以及效果是怎么样的。
                reuseIdentifier:TableSampleIdentifier];
    }
    
    //    UIImage *image = [UIImage imageNamed:@"superChargerPile_90"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0,0.0,headImage.size.width,headImage.size.height);
    button.frame = frame;
    [button setBackgroundImage:headImage forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    
    //    UIImage *image0 = [UIImage imageNamed:@"personInfo"];
    NSUInteger row = [indexPath row];
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.list objectAtIndex:row];
        if (row == 0) {
            //            cell.accessoryView = image0;
            cell.accessoryView = button;
        }
        else if(row == 1)
        {
            cell.detailTextLabel.text = name;
        }
        else if (row == 2)
        {
            cell.detailTextLabel.text = signature;
        }
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = [self.list2 objectAtIndex:row];
        if (row == 0) {
            //            cell.detailTextLabel.text = ID;
            //获取用户的聊天ID
            cell.detailTextLabel.text = [bixLocalAccount instance].username;
        }
        else if (row == 1)
        {
            cell.detailTextLabel.text = WechatID;
        }
        else if (row == 2)
        {
            cell.detailTextLabel.text = TeslaType;
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    NSLog(@"tableView.rowHeight is %f", tableView.rowHeight);
    return cell;
}
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
////    return [general_TableView titleForHeaderInSection:section];
//
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
////    return [general_TableView titleForFooterInSection:section];
//}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return [general_TableView tableView:tableView heightForRowAtIndexPath:indexPath];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        return tableView.rowHeight+75;
    }
    else
        return tableView.rowHeight;
    
}


#pragma mark delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中后的反显颜色即刻消失,即选中cell后，cell的高亮立刻消失；
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [general_TableView didSelectRowAtIndexPath:indexPath setingViewController:self];
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            [chooseImageSheet showInView:self.view];
        }
        else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"name" sender:self];
        }
        else if (indexPath.row == 2)
        {
//            NSString *noti = @"test the problem signature";
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"nameChange" object:noti];
            [self performSegueWithIdentifier:@"signature" sender:self];
        }
    }
    
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            //            [self performSegueWithIdentifier:@"ID" sender:self];
        }
        else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"WechatID" sender:self];
        }
        else if (indexPath.row == 2)
        {
            [self performSegueWithIdentifier:@"TeslaType" sender:self];
        }
        
    }
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UIActionSheetDelegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0://Take picture
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            [self presentViewController:picker animated:YES completion:nil];
            //            [self presentModalViewController:picker animated:YES];  此函数ios6之后已经废弃不用！
            break;
            
        case 1://From album
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        default:
            
            break;
    }
}

#pragma 拍照选择照片协议方法;
//当进入拍照模式拍照 并且点击Use photo后 或者 从本地图库选择图片后 会调用此方法;
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    //拍照和从本地图片库选择 mediaType都是    public.image
    NSLog(@"mediaType is %@", mediaType);
    
    NSData *data;
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        //读出拍的照片或者从本地图库选择的照片， 是原始的
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        
        hud = [MessageBox Toasting:@"正在处理" In:self.view];
        
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        [hud hide:YES];
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        bixCaptureViewController *captureView = [[bixCaptureViewController alloc] init];
        captureView.delegate = self;
        captureView.image = image;
        //隐藏UIImagePickerController本身的导航栏
        picker.navigationBar.hidden = YES;
        [picker pushViewController:captureView animated:YES];
    }
}

#pragma mark - 图片回传协议方法
-(void)passImage:(UIImage *)image
{
    imageView.image = image;
    //设置头像缩放成 60*60 的
    headImage = [self scaleFromImage:image];
    
    //上传头像 数据到服务器, PNG格式;
    request = [[RequestInfoFromServer alloc]init];
    [request sendAsynchronousPostImageRequest:headImage];
    
    //保存裁剪后的头像;
//    Account * accout = [appDelegate account];
//    accout.avatar = headImage;
    
    bixLocalAccount *account = [bixLocalAccount instance];
    //account.avatar = headImage;
    [account save];
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



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
