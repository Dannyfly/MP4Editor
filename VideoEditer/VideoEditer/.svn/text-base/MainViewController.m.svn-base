//
//  MainViewController.m
//  VideoEditer
//
//  Created by liulu on 13-7-26.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VideoEditController.h"

#define DEF_BTNLOADVIDEO_TAG 7291421

@interface MainViewController ()

@end

@implementation MainViewController

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
	// Do any additional setup after loading the view.
    
    UIImage* bgImg;
    if (IPHONE5) {
        bgImg = [UIImage imageNamed:@"background5.png"];
    } else {
        bgImg = [UIImage imageNamed:@"background.png"];
    }
    UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 20)];
    [self.view addSubview:bgImageView];
    bgImageView.image = bgImg;
    
    self.title = @"LoadView";
    
    UIButton* btnLoadVideo = [[UIButton alloc] initWithFrame:CGRectMake(35, 115, 250, 250)];
    [self.view addSubview:btnLoadVideo];
    [btnLoadVideo setBackgroundImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
    [btnLoadVideo addTarget:self action:@selector(btnLoadVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnLoadVideo.tag = DEF_BTNLOADVIDEO_TAG;
    
    UILabel* lblTip = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(btnLoadVideo.frame)+15, 100, 25)];
    [self .view addSubview:lblTip];
    lblTip.font = [UIFont systemFontOfSize:15.0f];
    lblTip.text = @"从外部读取文件:";
    lblTip.textColor = [UIColor whiteColor];
    lblTip.backgroundColor = [UIColor clearColor];
    [lblTip sizeToFit];
    
    _switch = [[UISwitch alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(btnLoadVideo.frame)+5, 50, 25)];
    [self.view addSubview:_switch];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/VideoCache/",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]]) {
        NSError *error;
        [[NSFileManager defaultManager]  createDirectoryAtPath:[NSString stringWithFormat:@"%@/VideoCache/",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]] withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"error:%@",error);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view viewWithTag:DEF_BTNLOADVIDEO_TAG].alpha = 1;
}

- (void)btnLoadVideoClicked:(UIButton*)sender
{
    if (_switch.on) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"加载视频" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", @"相册读取", nil];
        [sheet showInView:self.view];
    } else {
        VideoEditController* ctrl = [[VideoEditController alloc] init];
        ctrl.videoPath = [[NSBundle mainBundle] pathForResource:@"orig" ofType:@"mp4"];
        [self.navigationController pushViewController:ctrl animated:YES];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //拍摄
            //检查相机模式是否可用
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSLog(@"sorry, no camera or camera is unavailable!!!");
                return;
            }
            //获得相机模式下支持的媒体类型
            NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            BOOL canTakeVideo = NO;
            for (NSString* mediaType in availableMediaTypes) {
                if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
                    //支持摄像
                    canTakeVideo = YES;
                    break;
                }
            }
            //检查是否支持摄像
            if (!canTakeVideo) {
                NSLog(@"sorry, capturing video is not supported.!!!");
                return;
            }
            //创建图像选取控制器
            UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
            //设置图像选取控制器的来源模式为相机模式
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //设置图像选取控制器的类型为动态图像
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            //设置摄像图像品质
            imagePickerController.videoQuality = UIImagePickerControllerQualityType640x480;
            //设置最长摄像时间
            imagePickerController.videoMaximumDuration = 30;
            //允许用户进行编辑
            imagePickerController.allowsEditing = YES;
            //设置委托对象
            imagePickerController.delegate = self;
            //以模式视图控制器的形式显示
            [self presentViewController:imagePickerController animated:YES completion:^{}];
//            [self presentModalViewController:imagePickerController animated:YES];
//            [imagePickerController release];
        }
            break;
        case 1:
        {
            //相册
            UIImagePickerController* imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.delegate = self;
            imgPicker.allowsEditing = NO;
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPicker.mediaTypes = [[NSArray alloc] initWithObjects:@"public.movie", nil];
            [self presentViewController:imgPicker animated:YES completion:^{}];
        }
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL  * videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"found a video");
        NSData* videoData = [NSData dataWithContentsOfURL:videoURL];
        NSString* path = [NSString stringWithFormat:@"%@/VideoCache/cache.mp4",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if ([videoData writeToFile:path atomically:YES]) {
            [picker dismissViewControllerAnimated:YES completion:^{
                [UIView animateWithDuration:0.35 animations:^{
                    [self.view viewWithTag:DEF_BTNLOADVIDEO_TAG].alpha = 0;
                }completion:^(BOOL finished){
                    VideoEditController* ctrl = [[VideoEditController alloc] init];
                    ctrl.videoPath = path;
                    [self.navigationController pushViewController:ctrl animated:NO];
                }];
            }];
        }
    }
}

@end
