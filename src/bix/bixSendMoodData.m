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
#import "bixMomentDataItem.h"
#import "bixImageProxy.h"

@interface bixSendMoodData ()

@end

@implementation bixSendMoodData
{
    int timeOfNotification;
    UIImage *pickImage;
    AppDelegate* appDelegate;
    MBProgressHUD *hud;
    
    int flag_sendMoodData_success_or_not; // 标记本次发送是否成功;
    
    bixMomentDataItem *item;  //用于发送的momentDataItem;

//本来是设计用来存发送图片的NSURL， 但发送到前台不能实时响应，故取消这种设计，直接传数据给前台实时显示;
//    NSMutableArray *ImageURLArray;
    
//    bixMomentDataItem *item;
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
    flag_sendMoodData_success_or_not = 1;   //一进分享圈界面就默认 本次会发送成功，设置为1， 当发送不成功时，再设置为0;
    
    self.pictureNumber = 1;
    timeOfNotification = 0;
    //点击发送按钮，软键盘会自动取消，设置代理;
    self.textView.delegate = self;
    
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 5.0;
    
    self.imageView1.image = self.image1;
    
    self.addPictureButton.frame = CGRectMake(self.imageView2.frame.origin.x, self.imageView2.frame.origin.y,
                                             self.imageView2.frame.size.width, self.imageView2.frame.size.height);
    
    self.imageArray = [NSMutableArray arrayWithCapacity:9];//最多添加9张图片;
    [self.imageArray addObject:self.image1];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
}


-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"bixSendMoodData.m viewWillDisapper");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma PassImageDelegate

-(void)passImage:(UIImage *)image
{
    pickImage = image;
}
//
//
//- (IBAction)cancleSendMood:(id)sender {
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

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
    self.pictureNumber++;//添加的图片数目加1;
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
                
                [self.imageArray addObject:self.image2];
            }
                break;
            case 3:
            {
                self.image3 = [UIImage imageWithData:data];
                self.imageView3.image = self.image3;
                
                [self.imageArray addObject:self.image3];
            }
                break;
            case 4:
            {
                self.image4 = [UIImage imageWithData:data];
                self.imageView4.image = self.image4;
                
                [self.imageArray addObject:self.image4];
            }
                break;
            case 5:
            {
                self.image5 = [UIImage imageWithData:data];
                self.imageView5.image = self.image5;
                
                [self.imageArray addObject:self.image5];
            }
                break;
            case 6:
            {
                self.image6 = [UIImage imageWithData:data];
                self.imageView6.image = self.image6;
                
                [self.imageArray addObject:self.image6];
            }
                break;
            case 7:
            {
                self.image7 = [UIImage imageWithData:data];
                self.imageView7.image = self.image7;
                
                [self.imageArray addObject:self.image7];
            }
                break;
            case 8:
            {
                self.image8 = [UIImage imageWithData:data];
                self.imageView8.image = self.image8;
                
                [self.imageArray addObject:self.image8];
            }
                break;
            case 9:
            {
                self.image9 = [UIImage imageWithData:data];
                self.imageView9.image = self.image9;
                
                [self.imageArray addObject:self.image9];
            }
                break;
                
            default:
                break;
        }
       
        [hud hide:YES];
        self.view.userInteractionEnabled = YES;
        
        //隐藏UIImagePickerController本身的导航栏
        picker.navigationBar.hidden = YES;
        
        NSLog(@"end picker image");
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
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


- (IBAction)addPicture:(id)sender {
    
    if (self.pictureNumber >= 10) {
        [MessageBox Toast:@"最多只能添加9张图片哦!!" In: self.view];
        return ;
    }
    
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [chooseImageSheet showInView:self.view];
}

- (IBAction)sendTextAndPicture:(id)sender {
    //取消软键盘，让软键盘退下去;
    [self.textView resignFirstResponder];
    
    hud = [MessageBox Toasting:@"正在发送" In:self.view];
    
    NSLog(@"图片数组个数是 %d", [self.imageArray count]);
    NSLog(@"输入的文字是 %@", self.textView.text);
    if ([self.textView.text isEqualToString:@""]) {
        [MessageBox Toast:@"输入点文字呀..." In: self.view];
        return ;
    }

    if(flag_sendMoodData_success_or_not == 1)
    {
        Account *account = [bixLocalAccount instance];
        //account.avatar = @"http://121.40.72.197/upload/1171-g2ixyb.png";
//        account.nickname = account.username;
        
        item = [[bixMomentDataItem alloc]initWithSender:account];
        
        for (id obj in self.imageArray) {
            bixImageProxy *imageProxy = [[bixImageProxy alloc]initWithImage:obj];
            [item.imageProxyArray addObject:imageProxy];
        }
        //NSLog(@"item.uiImageData count is %d, self.mutableArray count is %d", [item.uiImageData count], [self.mutableArray count]);
        //NSLog(@"bixSendMoodData.m item.uiImageData count is %d", [item.uiImageData count]);
        
        item.textContent = self.textView.text;
        [[bixMomentDataSource defaultSource]addMomentDataItem:item];
        
        NSLog(@"bixSendMoodData.m momentDataItem number is %d", [[bixMomentDataSource defaultSource]numberOfMomentDataItem]);
    }
    
    if ((self.pictureNumber) == [self.imageArray count]) {
        [self.imageArray addObject:self.textView.text];
    }
    else if((self.pictureNumber+1) == [self.imageArray count])
    {
        [self.imageArray removeLastObject];
        [self.imageArray addObject:self.textView.text];
    }
    
    NSLog(@"text is %@", [self.imageArray objectAtIndex:([self.imageArray count]-1)]);
    //item 发送到服务器
    item.observer = self;
    [item push];
}

-(void)pushDidSuccess
{
    [hud hide:YES];
    [MessageBox Toasting:@"发送成功！" In:self.view];
    self.view.userInteractionEnabled = YES;
    
    //退出时，得清空之前的数组元素， 否则下次进来会一直叠加元素;
    [self.imageArray removeAllObjects];
    flag_sendMoodData_success_or_not = 1;
    
    [[self navigationController] popViewControllerAnimated:YES];
}

/*
-(void)parseDataItem:(NSNotification *)notification
{
    self.theResultData = notification.object;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self.theResultData options:NSJSONReadingMutableLeaves error:nil];
   
    NSArray *imageUrl = [result objectForKey:@"imgs"];
    
    for (id obj in imageUrl) {
        NSLog(@"image URL is %@", obj);
        [ImageURLArray addObject:[NSURL URLWithString:obj]];
        NSLog(@"NSURL is %@", [NSURL URLWithString:obj]);
    }
    
    // create MomentDataItem item
    // add item to MomentDataSource
    Account *account = [[AppDelegate get] account];
    account.avatarUrl = [NSURL URLWithString: @"http://img0.bdstatic.com/img/image/shouye/mxlyfs-9632102318.jpg"];
    account.nickname = account.username;
    
    bixMomentDataItem *item = [[bixMomentDataItem alloc]initWithSender:account];
    //    item.imgUrls = [NSMutableArray arrayWithArray:self.mutableArray];
    item.imgUrls = [NSMutableArray arrayWithArray:ImageURLArray];
//    item.imgUrls = [NSMutableArray arrayWithArray:testURLArray];
    item.textContent = self.textView.text;
    [[bixMomentDataSource defaultSource]addMomentDataItem:item];
    NSLog(@"momentDataItem number is %d", [[bixMomentDataSource defaultSource]numberOfMomentDataItem]);
    [ImageURLArray removeAllObjects];
}
*/

-(void)parseSuccessOrNot:(NSNotification *)notification
{
    NSLog(@"parseSuccessOrNot");
    if ([notification.object isEqualToString:@"success"]) {
        //发送成功才能给bixMomentViewController.m 发送通知，从而使 cell个数加1;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendOneMomentDataItem" object:self.textView.text];
        [hud hide:YES];
        [MessageBox Toasting:@"发送成功！" In:self.view];
        self.view.userInteractionEnabled = YES;
        
        //退出时，得清空之前的数组元素， 否则下次进来会一直叠加元素;
        [self.imageArray removeAllObjects];
        flag_sendMoodData_success_or_not = 1;
        
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else if([notification.object isEqualToString:@"networkLost"])
    {
        //清楚上次没发送成功的item;
//        [[bixMomentDataSource defaultSource]removeMomentDataItem:([[bixMomentDataSource defaultSource]numberOfMomentDataItem]-1)];
        NSLog(@"发送失败");
        flag_sendMoodData_success_or_not = 0;  //标记本次发送失败；
        [hud hide:YES];
        [MessageBox Toast:@"发送失败，请检查网络设置！" In:self.view];
        self.view.userInteractionEnabled = YES;

        timeOfNotification++;
        NSLog(@"timeOfNotification is %d", timeOfNotification);
        NSLog(@"mutableArray number is %d", [self.imageArray count]);
        for (id obj in self.imageArray) {
            NSLog(@"mutableArray is %@", obj);
        }
    }
    else
    {
        flag_sendMoodData_success_or_not = 0;  //标记本次发送失败；
        [hud hide:YES];
        [MessageBox Toast:@"发送失败，服务器出错！" In:self.view];
        self.view.userInteractionEnabled = YES;
    }
}

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
