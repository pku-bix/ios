//
//  bixSendMoodData.m
//  bix
//
//  Created by dsx on 14-11-4.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixSendMoodData.h"
#import "bixCaptureViewController.h"
#import "generalTableView.h"
#import "AppDelegate.h"
#import "RequestInfoFromServer.h"
#import "MessageBox.h"
#import "MBProgressHUD.h"

@interface bixSendMoodData ()

@end

@implementation bixSendMoodData
{
    int timeOfNotification;
    UIImage *pickImage;
    AppDelegate* appDelegate;
    RequestInfoFromServer* request;
    MBProgressHUD *hud;
    //用这个变量来标记发送是否成功，对应在点击发送按钮触发的事件;
//    int flag;
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
    self.pictureNumber = 1;
    timeOfNotification = 0;
    
//    flag = 0;  //
    self.imageView1.image = self.image1;
    
    self.mutableArray = [NSMutableArray arrayWithCapacity:9];//最多添加9张图片;
    [self.mutableArray addObject:self.image1];
   
//    self.textView
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseSuccessOrNot:) name:@"sendMomentDataSuccessOrNot" object:nil];
    NSLog(@"viewWillAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendMomentDataSuccessOrNot" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma PassImageDelegate

-(void)passImage:(UIImage *)image
{
    pickImage = image;
}


- (IBAction)cancleSendMood:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
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
    hud = [MessageBox Toast:@"处理中..." In: self.view];
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        switch (self.pictureNumber) {
            case 2:
            {
                self.image2 = [UIImage imageWithData:data];
                self.imageView2.image = self.image2;
                
                [self.mutableArray addObject:self.image2];
            }
                break;
            case 3:
            {
                self.image3 = [UIImage imageWithData:data];
                self.imageView3.image = self.image3;
                
                [self.mutableArray addObject:self.image3];
            }
                break;
            case 4:
            {
                self.image4 = [UIImage imageWithData:data];
                self.imageView4.image = self.image4;
                
                [self.mutableArray addObject:self.image4];
            }
                break;
            case 5:
            {
                self.image5 = [UIImage imageWithData:data];
                self.imageView5.image = self.image5;
                
                [self.mutableArray addObject:self.image5];
            }
                break;
            case 6:
            {
                self.image6 = [UIImage imageWithData:data];
                self.imageView6.image = self.image6;
                
                [self.mutableArray addObject:self.image6];
            }
                break;
            case 7:
            {
                self.image7 = [UIImage imageWithData:data];
                self.imageView7.image = self.image7;
                
                [self.mutableArray addObject:self.image7];
            }
                break;
            case 8:
            {
                self.image8 = [UIImage imageWithData:data];
                self.imageView8.image = self.image8;
                
                [self.mutableArray addObject:self.image8];
            }
                break;
            case 9:
            {
                self.image9 = [UIImage imageWithData:data];
                self.imageView9.image = self.image9;
                
                [self.mutableArray addObject:self.image9];
            }
                break;
                
            default:
                break;
        }
       
        [hud hide:YES];
        self.view.userInteractionEnabled = YES;
        //将二进制数据生成UIImage
        
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
//        [self performSegueWithIdentifier:@"sendMood" sender:self];
    }
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


- (IBAction)addPicture:(id)sender {
    self.pictureNumber++;//添加的图片数目加1;
    if (self.pictureNumber >= 10) {
        [MessageBox Toast:@"最多只能添加9张图片哦!!" In: self.view];
        return ;
    }
    
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [chooseImageSheet showInView:self.view];
}

- (IBAction)sendTextAndPicture:(id)sender {
   
    NSLog(@"图片数组个数是 %d", [self.mutableArray count]);
    NSLog(@"输入的文字是 %@", self.textView.text);
    if ([self.textView.text isEqualToString:@""]) {
        [MessageBox Toast:@"输入点文字呀..." In: self.view];
        return ;
    }
    
    if ((self.pictureNumber) == [self.mutableArray count]) {
        [self.mutableArray addObject:self.textView.text];
    }
    else if((self.pictureNumber+1) == [self.mutableArray count])
    {
        [self.mutableArray removeLastObject];
        [self.mutableArray addObject:self.textView.text];
    }
    NSLog(@"text is %@", [self.mutableArray objectAtIndex:([self.mutableArray count]-1)]);
//
    //切记不可在这个函数注册通知，否则没点击一次按钮就会注册一个相同的通知，最后会收到多个相同的数据;
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseSuccessOrNot:) name:@"sendMomentDataSuccessOrNot" object:nil];
    hud = [MessageBox Toasting:@"正在发送" In:self.view];
    
    request = [[RequestInfoFromServer alloc]init];
    [request sendAsynchronousPostMomentData:self.mutableArray];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"the textView.text is %@", self.textView.text);
    
//    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)parseSuccessOrNot:(NSNotification *)notification
{
    NSLog(@"parseSuccessOrNot");
    if ([notification.object isEqualToString:@"success"]) {
        //发送成功才能给bixMomentViewController.m 发送通知，从而使 cell个数加1;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendOneMomentDataItem" object:self.textView.text];
        [hud hide:YES];
        [MessageBox Toasting:@"发送成功！" In:self.view];
        self.view.userInteractionEnabled = YES;
        
        [self.mutableArray removeAllObjects];
        
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else if([notification.object isEqualToString:@"networkLost"])
    {
        NSLog(@"发送失败");
        [hud hide:YES];
        [MessageBox Toast:@"发送失败，请检查网络设置！" In:self.view];
        self.view.userInteractionEnabled = YES;

        timeOfNotification++;
        NSLog(@"timeOfNotification is %d", timeOfNotification);
        NSLog(@"mutableArray number is %d", [self.mutableArray count]);
        for (id obj in self.mutableArray) {
            NSLog(@"mutableArray is %@", obj);
        }
    }
    else
    {
        [hud hide:YES];
        [MessageBox Toast:@"发送失败，服务器出错！" In:self.view];
        self.view.userInteractionEnabled = YES;
    }

}

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
