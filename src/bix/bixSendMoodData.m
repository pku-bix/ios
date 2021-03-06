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
//#import "RequestInfoFromServer.h"
#import "MessageBox.h"
#import "MBProgressHUD.h"
#import "bixMomentDataItem.h"
#import "bixImageProxy.h"

@interface bixSendMoodData ()

@end

@implementation bixSendMoodData
{
    UIImage *pickImage;
    AppDelegate* appDelegate;
    MBProgressHUD *hud;
    UIButton *addPhotoButton;
    
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
    //一进分享圈界面就默认 本次会发送成功，设置为1， 当发送不成功时，再设置为0;
    flag_sendMoodData_success_or_not = 1;
    self.pictureNumber = 1;
    //点击发送按钮，软键盘会自动取消，设置代理;
    self.textView.delegate = self;
    
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 5.0;
    
    self.imageView1.image = self.image1;
    
    NSLog(@"Button X %f Y %f", self.addPictureButton.frame.origin.x, self.addPictureButton.frame.origin.y);
    
    self.addPictureButton.frame = CGRectMake(self.imageView2.frame.origin.x, self.imageView2.frame.origin.y,
                                             self.imageView2.frame.size.width, self.imageView2.frame.size.height);
    
    NSLog(@"Button X %f Y %f", self.imageView2.frame.origin.x, self.imageView2.frame.origin.y);
    
    addPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addPhotoButton setBackgroundImage:[UIImage imageNamed:@"addbutton.png"] forState:UIControlStateNormal];
    CGRect photoButtonFrame = CGRectMake(self.imageView2.frame.origin.x, self.imageView2.frame.origin.y,
                                         self.imageView2.frame.size.width, self.imageView2.frame.size.height);
    addPhotoButton.frame = photoButtonFrame;
    [addPhotoButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addPhotoButton];
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

-(void)adjustAddPhotoButtonPosition:(NSInteger)loc
{
    UIView *locView;
    switch (loc) {
        case 0:
            locView = self.imageView1;
            break;
        case 1:
            locView = self.imageView2;
            break;
        case 2:
            locView = self.imageView3;
            break;
        case 3:
            locView = self.imageView4;
            break;
        case 4:
            locView = self.imageView5;
            break;
        case 5:
            locView = self.imageView6;
            break;
        case 6:
            locView = self.imageView7;
            break;
        case 7:
            locView = self.imageView8;
            break;
        case 8:
            locView = self.imageView9;
            break;
        case 9:
            addPhotoButton.hidden = YES;
            break;
        default:
            break;
    }
    addPhotoButton.frame = CGRectMake(locView.frame.origin.x, locView.frame.origin.y,
                                      locView.frame.size.width, locView.frame.size.height);
}


#pragma mark 拍照选择照片协议方法
//当进入拍照模式拍照 并且点击Use photo后 或者 从本地图库选择图片后 会调用此方法;
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.pictureNumber++;//添加的图片数目加1;
    
    [self adjustAddPhotoButtonPosition:self.pictureNumber];
    
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
                self.imageView2.image = [UIImage imageWithData:data];
                [self.imageArray addObject:self.imageView2.image];
            }
                break;
            case 3:
            {
                self.imageView3.image = [UIImage imageWithData:data];
                [self.imageArray addObject:self.imageView3.image];
            }
                break;
            case 4:
            {
                self.imageView4.image = [UIImage imageWithData:data];
                [self.imageArray addObject:self.imageView4.image];
            }
                break;
            case 5:
            {
                self.imageView5.image = [UIImage imageWithData:data];
                [self.imageArray addObject:self.imageView5.image];
            }
                break;
            case 6:
            {
                self.imageView6.image = [UIImage imageWithData:data];
                [self.imageArray addObject:self.imageView6.image];
            }
                break;
            case 7:
            {
                self.imageView7.image = [UIImage imageWithData:data];
                [self.imageArray addObject:self.imageView7.image];
            }
                break;
            case 8:
            {
                self.imageView8.image = [UIImage imageWithData:data];
                [self.imageArray addObject:self.imageView8.image];
            }
                break;
            case 9:
            {
                self.imageView9.image = [UIImage imageWithData:data];
                [self.imageArray addObject:self.imageView9.image];
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

- (void)addPicture
{    
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
    self.view.userInteractionEnabled = YES;
    
    NSLog(@"图片数组个数是 %d", [self.imageArray count]);
    NSLog(@"输入的文字是 %@", self.textView.text);
    if ([self.textView.text isEqualToString:@""]) {
        [MessageBox Toast:@"输入点文字呀..." In: self.view];
        [hud hide:YES];
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
        NSLog(@"%d", item.imageProxyArray.count);
        
        NSLog(@"bixSendMoodData.m momentDataItem number is %d", [[bixMomentDataSource defaultSource]numberOfMomentDataItem]);
        item = [[bixMomentDataSource defaultSource]getMomentAtIndex:0];
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

- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
