//
//  VideoEditController.m
//  VideoEditer
//
//  Created by Clark on 13-8-22.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "VideoEditController.h"
#include "lm_time.h"

#define DEF_MAGICSCROLLVIEW_TAG 941646
#define DEF_MAGICDRAWSCROLLVIEW_TAG 941647
#define DEF_MUSICSCROLLVIEW_TAG 941648
#define DEF_ACTIONCACHEVIEW_TAT 9101525

@interface VideoEditController ()

@end

@implementation VideoEditController

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
    self.view.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    // 创建导航
    [self createNav];
    // 创建播放视频区域
    [self createVideoPanel];
    // 创建编辑缓存区
    [self createActionCacheView];
    //创建涂鸦视图区域
    [self createDrawView];
    // 创建按钮点击切换区
    [self createBtnPanel];
    //编辑操作区域
    [self creatEditViews];
    //设置初始编辑模式
    [self doMusic:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    _oldBounds = self.navigationController.view.bounds;
    if (IOS7) {
        self.navigationController.view.bounds = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
    } else {
        self.navigationController.view.bounds = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT+20);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.view.bounds = _oldBounds;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.navigationController.navigationBar.hidden = NO;
    
    [_playerView stopPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 创建界面显示面板

//初始化导航条
- (void)createNav {
    UIImage *imgBackNormal = [UIImage imageNamed:@"btn_goback_normal"];
    UIImage *imgBackPress = [UIImage imageNamed:@"btn_goback_pressed"];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(10, 15, imgBackNormal.size.width, imgBackNormal.size.height);
    [btnBack setBackgroundImage:imgBackNormal forState:UIControlStateNormal];
    [btnBack setBackgroundImage:imgBackPress forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    UIImage *imgShareNormal = [UIImage imageNamed:@"btn_share_normal"];
    UIImage *imgSharePress = [UIImage imageNamed:@"btn_share_pressed"];
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(CGRectGetMaxX(btnBack.frame) + 185, 15, imgShareNormal.size.width, imgShareNormal.size.height);
    [btnShare setBackgroundImage:imgShareNormal forState:UIControlStateNormal];
    [btnShare setBackgroundImage:imgSharePress
                        forState:UIControlStateHighlighted];
    [btnShare addTarget:self action:@selector(goShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShare];
    
    UIImage *imgSelectNormal = [UIImage imageNamed:@"btn_finished_normal"];
    UIImage *imgSelectPress = [UIImage imageNamed:@"btn_finished_pressed"];
    UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSelect.frame = CGRectMake(SCREEN_WIDTH - 10 - imgSelectNormal.size.width, 15, imgSelectNormal.size.width, imgSelectNormal.size.height);
    [btnSelect setBackgroundImage:imgSelectNormal forState:UIControlStateNormal];
    [btnSelect setBackgroundImage:imgSelectPress forState:UIControlStateHighlighted];
    [btnSelect addTarget:self action:@selector(goSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSelect];
}

// 初始化视频播放区

- (void)createVideoPanel {
    UIImage *playVideoImg = [UIImage imageNamed:@"videoview_frame"];
    
    _playerView = [[VEVideoPlayingView alloc] initWithFrame:CGRectMake(10, 55, playVideoImg.size.width, playVideoImg.size.height-50)];
    [self.view addSubview: _playerView];

    _playerView.filePath = self.videoPath;
    _playerView.delegate = self;
    
    _playVideoView = [[UIImageView alloc] initWithImage:playVideoImg];
    _playVideoView.frame = CGRectMake(10, 55, playVideoImg.size.width, playVideoImg.size.height-50);
    _playVideoView.image = playVideoImg;
    [self.view addSubview:_playVideoView];
    
    _playVideoProgressBar = [[ProgressBar alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_playVideoView.frame)-5, 300, 14)];
    _playVideoProgressBar.delegate = self;
    [self.view addSubview:_playVideoProgressBar];
    [_playVideoProgressBar setProgress:0];
}

- (void)createDrawView
{
    _drawView = [[MyView alloc] initWithFrame:_playVideoView.frame];
    [_drawView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_drawView];
    [self.view bringSubviewToFront:_drawView];
    _drawView.userInteractionEnabled = NO;
    _drawView.hidden = YES;
}

- (void)createActionCacheView
{
    _actionCacheView = [[PageScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playVideoView.frame)+10, SCREEN_WIDTH, 38)];
    _actionCacheView.tag = DEF_ACTIONCACHEVIEW_TAT;
    _actionCacheView.showsHorizontalScrollIndicator = NO;
    [_actionCacheView refreshScrollView];
    _actionCacheView.showsVerticalScrollIndicator = NO;
    [_actionCacheView refreshScrollView];
    [_actionCacheView scrollRectToVisible:CGRectMake(0, 0, _actionCacheView.frame.size.width, _actionCacheView.frame.size.height) animated:YES];
    [self.view addSubview:_actionCacheView];
}

// 初始化按钮操作区域
- (void)createBtnPanel {
    UIImage *imgMagicNormal = [UIImage imageNamed:@"btn_magic_normal"];
    UIImage *imgMagicPress = [UIImage imageNamed:@"btn_magic_pressed"];
    _btnMagic = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMagic.frame = CGRectMake(30, CGRectGetMaxY(_actionCacheView.frame) + 10, imgMagicNormal.size.width, imgMagicNormal.size.height);
    [_btnMagic setBackgroundImage:imgMagicNormal forState:UIControlStateNormal];
    [_btnMagic setBackgroundImage:imgMagicPress forState:UIControlStateHighlighted];
    [_btnMagic addTarget:self action:@selector(doMagic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnMagic];
    
    UIImage *imgCutNormal = [UIImage imageNamed:@"btn_cut_normal"];
    UIImage *imgCutPress = [UIImage imageNamed:@"btn_cut_pressed"];
    _btnCut = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCut.frame = CGRectMake(SCREEN_WIDTH - 30 - imgCutNormal.size.width, CGRectGetMaxY(_actionCacheView.frame) + 10, imgCutNormal.size.width, imgCutNormal.size.height);
    [_btnCut setBackgroundImage:imgCutNormal forState:UIControlStateNormal];
    [_btnCut setBackgroundImage:imgCutPress forState:UIControlStateHighlighted];
    [_btnCut addTarget:self action:@selector(doCut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCut];
    
    UIImage *imgMusicNormal = [UIImage imageNamed:@"btn_add_bgmusic_normal"];
    UIImage *imgMusicPress = [UIImage imageNamed:@"btn_add_bgmusic_pressed"];
    _btnMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMusic.frame = CGRectMake(CGRectGetMaxX(_btnMagic.frame) + (CGRectGetMinX(_btnCut.frame) - CGRectGetMaxX(_btnMagic.frame)) / 2.0 - imgMusicNormal.size.width / 2.0, CGRectGetMaxY(_actionCacheView.frame) + 10, imgMusicNormal.size.width, imgMusicNormal.size.height);
    [_btnMusic setBackgroundImage:imgMusicNormal forState:UIControlStateNormal];
    [_btnMusic setBackgroundImage:imgMusicPress forState:UIControlStateHighlighted];
    [_btnMusic addTarget:self action:@selector(doMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnMusic];
}

// 初始化按编辑操作区域
- (void)creatEditViews
{
    UIImageView* imgLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videoview_line"]];
    imgLineView.frame = CGRectMake(0, CGRectGetMaxY(_actionCacheView.frame) + 42, SCREEN_WIDTH, 3);
    [self.view addSubview:imgLineView];
    
    _imgSelectEditType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_edit_type"]];
    _imgSelectEditType.frame = CGRectMake(_btnMagic.center.x - 8, CGRectGetMaxY(_actionCacheView.frame) + 35, _imgSelectEditType.frame.size.width, _imgSelectEditType.frame.size.height);
    [self.view addSubview:_imgSelectEditType];
    
    if (!_magicView) {
        _magicView  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_actionCacheView.frame) + 45, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_actionCacheView.frame) + 44)];
        _magicView.backgroundColor = [UIColor colorWithRed:29/255.0 green:29/255.0 blue:29/255.0 alpha:1.0];
        //时间轴
        _magicTimeline = [[VETimelineView alloc] initWithFrame:CGRectMake(10, 7, 300, 35)];
        _magicTimeline.videoWidth = _playerView.mediaFormat._width;
        _magicTimeline.videoHeight = _playerView.mediaFormat._height;
        _magicTimeline.videoLength = _playerView.mediaFormat._totaltime;
        _magicTimeline.mediaEidtor = _playerView.mediaEditor;
//        _magicTimeline.delegate = self;
        [_magicView addSubview:_magicTimeline];
        [_magicTimeline loadTimelineImgList];
        //滑动菜单
        UIImage* img = [UIImage imageNamed:@"action_framewithbg"];
        //涂鸦
        _magicDrawPageView = [[PageScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 38)];
        _magicDrawPageView.tag = DEF_MAGICDRAWSCROLLVIEW_TAG;
        _magicDrawPageView.showsHorizontalScrollIndicator = NO;
        [_magicDrawPageView refreshScrollView];
        _magicDrawPageView.showsVerticalScrollIndicator = NO;
        NSMutableArray *arrayDraw = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i *(img.size.width + 10)+7.5, 2, img.size.width, img.size.height)];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            if (i == 0) {
                [btn setTitle:@"涂鸦" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            if (i == 1) {
                [btn setTitle:@"清空" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            if (i == 2) {
                [btn setTitle:@"保存" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            if (i == 3) {
                [btn setTitle:@"开始" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            [arrayDraw addObject:btn];
        }
        [_magicDrawPageView setViewArray:arrayDraw];
        [_magicDrawPageView refreshScrollView];
        [_magicDrawPageView scrollRectToVisible:CGRectMake(0, 0, _magicDrawPageView.frame.size.width, _magicDrawPageView.frame.size.height) animated:YES];
        [_magicView addSubview:_magicDrawPageView];
        //水印
        _magicPageView = [[PageScrollView alloc] initWithFrame:CGRectMake(0, _magicView.frame.size.height, SCREEN_WIDTH, 38)];
        _magicPageView.tag = DEF_MAGICSCROLLVIEW_TAG;
        _magicPageView.showsHorizontalScrollIndicator = NO;
        [_magicPageView refreshScrollView];
        _magicPageView.showsVerticalScrollIndicator = NO;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i *(img.size.width + 10)+7.5, 2, img.size.width, img.size.height)];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            if (i == 0) {
                [btn setTitle:@"滤镜" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            if (i == 1) {
                [btn setTitle:@"黑白" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            if (i == 2) {
                [btn setTitle:@"反色" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            [array addObject:btn];
        }
        [_magicPageView setViewArray:array];
        [_magicPageView refreshScrollView];
        [_magicPageView scrollRectToVisible:CGRectMake(0, 0, _magicPageView.frame.size.width, _magicPageView.frame.size.height) animated:YES];
        [_magicView addSubview:_magicPageView];
    }
    
    if (!_musicView) {
        _musicView  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_actionCacheView.frame) + 45, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_actionCacheView.frame) + 44)];
        _musicView.backgroundColor = [UIColor colorWithRed:29/255.0 green:29/255.0 blue:29/255.0 alpha:1.0];
        _musicView.userInteractionEnabled = YES;
        
        UIImage* img = [UIImage imageNamed:@"action_framewithbg"];
        _musicPageView = [[PageScrollView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 38)];
        _musicPageView.tag = DEF_MUSICSCROLLVIEW_TAG;
        _musicPageView.showsHorizontalScrollIndicator = NO;
        [_musicPageView refreshScrollView];
        _musicPageView.showsVerticalScrollIndicator = NO;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i *(img.size.width + 10)+7.5, 2, img.size.width, img.size.height)];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            if (i == 0) {
                [btn setTitle:@"音乐1" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            if (i == 1) {
                [btn setTitle:@"音乐2" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            if (i == 2) {
                [btn setTitle:@"音乐3" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            }
            [array addObject:btn];
        }
        [_musicPageView setViewArray:array];
        [_musicPageView refreshScrollView];
        [_musicPageView scrollRectToVisible:CGRectMake(0, 0, _musicPageView.frame.size.width, _musicPageView.frame.size.height) animated:YES];
        [_musicView addSubview:_musicPageView];
        
        UILabel* lblAudio = [[UILabel alloc] init];
        lblAudio.text = @"原音";
        lblAudio.font = [UIFont systemFontOfSize:14.0f];
        lblAudio.textColor = [UIColor whiteColor];
        [lblAudio sizeToFit];
        lblAudio.frame = CGRectMake(30, 64, lblAudio.frame.size.width, lblAudio.frame.size.height);
        lblAudio.backgroundColor = [UIColor clearColor];
        [_musicView addSubview:lblAudio];
        
        UILabel* lblMusic = [[UILabel alloc] init];
        lblMusic.text = @"配音";
        lblMusic.font = [UIFont systemFontOfSize:14.0f];
        lblMusic.textColor = [UIColor whiteColor];
        [lblMusic sizeToFit];
        lblMusic.frame = CGRectMake(265, 64, lblMusic.frame.size.width, lblMusic.frame.size.height);
        lblMusic.backgroundColor = [UIColor clearColor];
        [_musicView addSubview:lblMusic];
        
        _musicSlider = [[MusicSlider alloc] initWithFrame:CGRectMake(62.5, 62, 195, 23)];
        _musicSlider.delegate = self;
        [_musicView addSubview:_musicSlider];
        [_musicSlider setSliderValue:0.5];
        
    }
    
    if (!_cutView) {
        _cutView  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_actionCacheView.frame) + 45, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_actionCacheView.frame) + 44)];
        _cutView.backgroundColor = [UIColor colorWithRed:29/255.0 green:29/255.0 blue:29/255.0 alpha:1.0];
        
        //时间轴
        _cutTimeline = [[VETimelineView alloc] initWithFrame:CGRectMake(10, 30, 300, 35)];
        _cutTimeline.videoWidth = _playerView.mediaFormat._width;
        _cutTimeline.videoHeight = _playerView.mediaFormat._height;
        _cutTimeline.videoLength = _playerView.mediaFormat._totaltime;
        _cutTimeline.mediaEidtor = _playerView.mediaEditor;
        _cutTimeline.delegate = self;
        [_cutView addSubview:_cutTimeline];
        [_cutTimeline loadTimelineImgList];
    }
    
    //设置初始化操作view的位置
    _magicView.frame = CGRectMake(-_magicView.frame.size.width, _magicView.frame.origin.y, _magicView.frame.size.width, _magicView.frame.size.height);
    _cutView.frame = CGRectMake(SCREEN_WIDTH, _cutView.frame.origin.y, _cutView.frame.size.width, _cutView.frame.size.height);
    [self.view addSubview:_magicView];
    [self.view addSubview:_musicView];
    [self.view addSubview:_cutView];
}

- (void)reloadProgressView:(int64_t)beginTime andEndTime:(int64_t)endTime
{
    CGFloat totalTime = _playerView.mediaFormat._totaltime;
    _playVideoProgressBar.beginValue = beginTime/totalTime;
    _playVideoProgressBar.endValue = endTime/totalTime;
    _playVideoProgressBar.progress = beginTime/totalTime;
    
    _magicTimeline.beginOrigin = _cutTimeline.videoStartTime;
    _magicTimeline.endOrigin = _cutTimeline.videoEndTime;
}

#pragma -mark 点击按钮事件

- (void)goBack:(id)sender {
    [_playerView stopPlay];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goShare:(id)sender {
    // 分享
    NSLog(@"分享");
}

- (void)goSelect:(id)sender {
    // 完成录制视频
    NSLog(@"完成录制视频");
//    [_playerView stopPlay];
    NSString* path = [NSString stringWithFormat:@"%@/VideoCache/saveed.mp4",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    [_playerView saveFileToPath:path];
}

- (void)doMagic:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _imgSelectEditType.frame = CGRectMake(_btnMagic.center.x - 8, CGRectGetMaxY(_actionCacheView.frame) + 35, _imgSelectEditType.frame.size.width, _imgSelectEditType.frame.size.height);
        //移动各个view
        _magicView.frame = CGRectMake(0, _magicView.frame.origin.y, _magicView.frame.size.width, _magicView.frame.size.height);
        _musicView.frame = CGRectMake(-_musicView.frame.size.width, _musicView.frame.origin.y, _musicView.frame.size.width, _musicView.frame.size.height);
        _cutView.frame = CGRectMake(-_cutView.frame.size.width-_musicView.frame.size.width, _cutView.frame.origin.y, _cutView.frame.size.width, _cutView.frame.size.height);
        
    } completion:^(BOOL finished){}];
    UIImage *imgMagicPress = [UIImage imageNamed:@"btn_magic_pressed"];
    UIImage *imgCutNormal = [UIImage imageNamed:@"btn_cut_normal"];
    UIImage *imgMusicNormal = [UIImage imageNamed:@"btn_add_bgmusic_normal"];
    [_btnMagic setBackgroundImage:imgMagicPress forState:UIControlStateNormal];
    [_btnMusic setBackgroundImage:imgMusicNormal forState:UIControlStateNormal];
    [_btnCut setBackgroundImage:imgCutNormal forState:UIControlStateNormal];
    
    [self showVideoActionList];
    
    // 完成录制视频
    NSLog(@"doMagic");
}

- (void)doMusic:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _imgSelectEditType.frame = CGRectMake(_btnMusic.center.x - 8, CGRectGetMaxY(_actionCacheView.frame) + 35, _imgSelectEditType.frame.size.width, _imgSelectEditType.frame.size.height);
        
        //移动各个view
        _magicView.frame = CGRectMake(SCREEN_WIDTH, _magicView.frame.origin.y, _magicView.frame.size.width, _magicView.frame.size.height);
        _musicView.frame = CGRectMake(0, _musicView.frame.origin.y, _musicView.frame.size.width, _musicView.frame.size.height);
        _cutView.frame = CGRectMake(-_cutView.frame.size.width, _cutView.frame.origin.y, _cutView.frame.size.width, _cutView.frame.size.height);
    } completion:^(BOOL finished){}];
    UIImage *imgMagicNormal = [UIImage imageNamed:@"btn_magic_normal"];
    UIImage *imgCutNormal = [UIImage imageNamed:@"btn_cut_normal"];
    UIImage *imgMusicPress = [UIImage imageNamed:@"btn_add_bgmusic_pressed"];
    [_btnMagic setBackgroundImage:imgMagicNormal forState:UIControlStateNormal];
    [_btnMusic setBackgroundImage:imgMusicPress forState:UIControlStateNormal];
    [_btnCut setBackgroundImage:imgCutNormal forState:UIControlStateNormal];
    
    [self showAudioActionList];
    
    // 完成录制视频
    NSLog(@"doMusic");
}

- (void)doCut:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _imgSelectEditType.frame = CGRectMake(_btnCut.center.x - 8, CGRectGetMaxY(_actionCacheView.frame) + 35, _imgSelectEditType.frame.size.width, _imgSelectEditType.frame.size.height);
        
        //移动各个view
        _magicView.frame = CGRectMake(SCREEN_WIDTH+_magicView.frame.size.width, _magicView.frame.origin.y, _magicView.frame.size.width, _magicView.frame.size.height);
        _musicView.frame = CGRectMake(SCREEN_WIDTH, _musicView.frame.origin.y, _musicView.frame.size.width, _musicView.frame.size.height);
        _cutView.frame = CGRectMake(0, _cutView.frame.origin.y, _cutView.frame.size.width, _cutView.frame.size.height);
    } completion:^(BOOL finished){}];
    UIImage *imgMagicNormal = [UIImage imageNamed:@"btn_magic_normal"];
    UIImage *imgCutPress = [UIImage imageNamed:@"btn_cut_pressed"];
    UIImage *imgMusicNormal = [UIImage imageNamed:@"btn_add_bgmusic_normal"];
    [_btnMagic setBackgroundImage:imgMagicNormal forState:UIControlStateNormal];
    [_btnMusic setBackgroundImage:imgMusicNormal forState:UIControlStateNormal];
    [_btnCut setBackgroundImage:imgCutPress forState:UIControlStateNormal];
    _actionCacheView.hidden = YES;
    // 完成录制视频
    NSLog(@"doCut");
}

- (void)changeMagicType:(MagicType)type
{
    switch (type) {
        case MagicTypeWatermark:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _magicPageView.frame = CGRectMake(0, _magicView.frame.size.height, SCREEN_WIDTH, 38);
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.3 animations:^{
                    _magicDrawPageView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 38);
                    _drawView.userInteractionEnabled = YES;
                    _drawView.hidden = NO;
                }];
            }];
        }
            break;
        case MagicTypeFilter:
        {
            _drawView.userInteractionEnabled = NO;
            _drawView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                _magicDrawPageView.frame = CGRectMake(0, _magicView.frame.size.height, SCREEN_WIDTH, 38);
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.3 animations:^{
                    _magicPageView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 38);
                }];
            }];
        }
        default:
            break;
    }
}

- (UIImage*)saveDrawImg
{
    UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 2.0);
    //    UIGraphicsBeginImageContext(self.drawView.bounds.size);
    [_drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    NSString* path = [NSString stringWithFormat:@"%@/VideoCache/Watermark.png",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    
    return image;
}

#pragma mark -
#pragma mark playViewDelegate
-(void)videoPlayingViewStartPlay
{
    
}

-(void)videoPlayingViewStopPlay
{
    
}

-(void)videoPlayingViewPausePlay
{
    
}

-(void)videoPlayingViewResumePlay
{
    
}

-(void)videoPlayingTime:(int64_t)time
{
    @autoreleasepool {
        CGFloat progress = time / (CGFloat)_playerView.mediaFormat._totaltime;
        //到主线程刷新进度条
        dispatch_sync(dispatch_get_main_queue(), ^{
            _playVideoProgressBar.progress = progress;
        });
    }
}

-(void)videoSavingPercentage:(int)value :(int)type
{
    switch (type) {
        case 3:
        {
            //保存
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_saveMaskView) {
                    _saveMaskView = [[UIView alloc] initWithFrame:self.view.frame];
                    _saveMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
                    [self.view addSubview:_saveMaskView];
                    [self.view bringSubviewToFront:_saveMaskView];
                    
                    UIImageView* bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waiting_view_background"]];
                    [_saveMaskView addSubview:bgImg];
                    bgImg.center = _saveMaskView.center;
                    
                    UILabel* lblSave = [[UILabel alloc] initWithFrame:CGRectMake(43, 20, 200, 30)];
                    lblSave.backgroundColor = [UIColor clearColor];
                    lblSave.font = [UIFont systemFontOfSize:14.0f];
                    lblSave.textColor = [UIColor whiteColor];
                    lblSave.text = @"保存中...";
                    lblSave.textAlignment = NSTextAlignmentCenter;
                    [bgImg addSubview:lblSave];
                    
                    _saveProgressview = [[UIProgressView alloc] initWithFrame:CGRectMake(43, 50, 200, 20)];
                    [_saveProgressview setProgressViewStyle:UIProgressViewStyleDefault];
                    [bgImg addSubview:_saveProgressview];
                    //先设置0.01避免拉伸动画问题
                    [_saveProgressview setProgress:0.01 ];
                    
                    [UIView exChangeOut:bgImg dur:0.5];
                }
                [_saveProgressview setProgress:value/100.0f];
            });
            
            if (value == 100) {
                __block NSString *video = SAVE_FILE;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(video)){
                        NSLog(@"video is : %@", video);
                        UISaveVideoAtPathToSavedPhotosAlbum(video, self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
                    }
                });
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)video:(NSString *)videoPath
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    NSLog(@"Finished with error: %@", error);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark timelineDelegate
- (void)resetBeginTime:(int64_t)beginTime andEndTime:(int64_t)endTime
{
    int64_t time;
    _playerView.beginTime = beginTime;
    _playerView.endTime = endTime;
    
    time = _playerView.mediaEditor->GetCurrentPlayTime();
    if (time < beginTime || time > endTime) {
        _playerView.curTime = beginTime;
    }
    [self reloadProgressView:beginTime andEndTime:endTime];
}

#pragma mark barDelegate
- (void)musicSliderValueDidChanged:(CGFloat)sliderValue
{
    
}

- (void)progressChanged:(CGFloat)progressValue
{
    FFPLAY_STATE state = _playerView.mediaEditor->GetPlayState();
    if (state != FFPLAY_STATE_CLOSED){
        int64_t time = _playerView.mediaFormat._totaltime;
        _playerView.mediaEditor->Seek((int64_t)((CGFloat)time*progressValue));
    }
}

- (void)btnActionClicked:(UIButton*)sender
{
    if (sender.superview.tag == DEF_MAGICDRAWSCROLLVIEW_TAG) {
        //涂鸦
        _magicDrawPageView.selectedIndex = sender.tag;
        if (sender.tag == 0) {
            //第一个按钮，切换到滤镜
            [self changeMagicType:MagicTypeFilter];
            return;
        }
        if (sender.tag == 1) {
            //无，清空效果
            [_drawView clear];
            return;
        }
        if (sender.tag == 2) {
            //临时保存按钮保存图片
            [self saveDrawImg];
            NSString* path = [NSString stringWithFormat:@"%@/VideoCache/Watermark.png",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
            _drawView.hidden = YES;
            
            WatermarkFilterAction* act = [[WatermarkFilterAction alloc] init];
            act.beginTime = _magicTimeline.videoStartTime;
            act.endTime = _magicTimeline.videoEndTime;
            act.imgPath = path;
            act.width = _playerView.frame.size.width;
            act.height = _playerView.frame.size.height;
            
            [_playerView addWatermark:act];
            [self showVideoActionList];
        }
        if (sender.tag == 3) {
            _drawView.userInteractionEnabled = YES;
            _drawView.hidden = NO;
        }
    } else if (sender.superview.tag == DEF_MAGICSCROLLVIEW_TAG) {
        //水印
        _magicPageView.selectedIndex = sender.tag;
        if (sender.tag == 0) {
            //第一个按钮，切换到涂鸦
            [self changeMagicType:MagicTypeWatermark];
            return;
        }
        [self addFilterAction:sender.tag];
        [self showVideoActionList];
        
    } else if (sender.superview.tag == DEF_MUSICSCROLLVIEW_TAG) {
        //音乐
        _musicPageView.selectedIndex = sender.tag;
        [self addAudioActionWithTag:sender.tag];
    } else if (sender.superview.tag == DEF_ACTIONCACHEVIEW_TAT) {
        //缓存
        _actionCacheView.selectedIndex = sender.tag;
        switch (_editType) {
            case EditTypeMagic:
            {
                ActionItem item = _playerView.mediaEditor->GetVideoActionItemById(sender.tag);
                BaseAction* act = [SerializationAction serializationActionWithItem:&item];
                [self reloadEditViewByAction:act];
            }
                break;
            case EditTypeMusic:
            {
                ActionItem item = _playerView.mediaEditor->GetAudioActionItemById(sender.tag);
                BaseAction* act = [SerializationAction serializationActionWithItem:&item];
                [self reloadEditViewByAction:act];
            }
                break;
            default:
                break;
        }
    }
}

- (void)reloadEditViewByAction:(BaseAction*)action
{
    switch (_editType) {
        case EditTypeMusic:
        {
            if ([action.actionName isEqualToString:@"AddAudioAction"]) {
                _musicPageView.selectedIndex = 2;
                AddAudioAction* act = (AddAudioAction*)action;
                [_musicSlider setSliderValue:act.volumeRate];
            }
        }
            break;
        case EditTypeMagic:
        {
            if ([action.actionName isEqualToString:@"MonochromeFilterAction"]) {
                //黑白滤镜
                [self changeMagicType:MagicTypeFilter];
                _magicPageView.selectedIndex = 1;
                MonochromeFilterAction* act = (MonochromeFilterAction*)action;
                [_magicTimeline reloadViewWithStartTime:act.beginTime andEndTime:act.endTime];
                
            } else if ([action.actionName isEqualToString:@"NegativeFilterAction"]) {
                //反色滤镜
                [self changeMagicType:MagicTypeFilter];
                _magicPageView.selectedIndex = 2;
                NegativeFilterAction* act = (NegativeFilterAction*)action;
                [_magicTimeline reloadViewWithStartTime:act.beginTime andEndTime:act.endTime];
                
            } else if ([action.actionName isEqualToString:@"WatermarkFilterAction"]) {
                //水印滤镜
                [self changeMagicType:MagicTypeWatermark];
                WatermarkFilterAction* act = (WatermarkFilterAction*)action;
                [_magicTimeline reloadViewWithStartTime:act.beginTime andEndTime:act.endTime];
            }
        }
            break;
        default:
            break;
    }
}

- (void)showVideoActionList
{
    _editType = EditTypeMagic;
    _actionCacheView.hidden = NO;
    UIImage* img = [UIImage imageNamed:@"action_framewithbg"];
    int num = _playerView.mediaEditor->GetVideoActionNum();
    NSMutableArray *arrayDraw = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<num; i++) {
        ActionItem item = _playerView.mediaEditor->GetVideoActionItemById(i);
        
        BaseAction* act = [SerializationAction serializationActionWithItem:&item];
        
        //增加btn
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i *(img.size.width + 10)+7.5, 2, img.size.width, img.size.height)];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        //检查名字
        NSString* name = @"";
        if ([act.actionName isEqualToString:@"MonochromeFilterAction"]) {
            name = @"黑白";
        } else if ([act.actionName isEqualToString:@"NegativeFilterAction"]) {
            name = @"反色";
        } else if ([act.actionName isEqualToString:@"WatermarkFilterAction"]) {
            name = @"涂鸦";
        }
        if ([name isEqualToString:@"涂鸦"]) {
            NSString* path = [NSString stringWithFormat:@"%@/VideoCache/Watermark.png",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
            [btn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        } else {
            [btn setTitle:name forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCallBack:)];
        [btn addGestureRecognizer:longPress];
        [arrayDraw addObject:btn];
    }
    
    [_actionCacheView setViewArray:arrayDraw];
    [_actionCacheView refreshScrollView];
    [_actionCacheView scrollRectToVisible:CGRectMake(_actionCacheView.contentSize.width - _actionCacheView.frame.size.width, 0, _actionCacheView.frame.size.width, _actionCacheView.frame.size.height) animated:YES];
    _actionCacheView.selectedIndex = _actionCacheView.viewArray.count - 1;
}

- (void)showAudioActionList
{
    _editType = EditTypeMusic;
    _actionCacheView.hidden = NO;
    UIImage* img = [UIImage imageNamed:@"action_framewithbg"];
    int num = _playerView.mediaEditor->GetAudioActionNum();
    NSMutableArray *arrayDraw = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<num; i++) {
        ActionItem item = _playerView.mediaEditor->GetAudioActionItemById(i);
        
        BaseAction* act = [SerializationAction serializationActionWithItem:&item];
        
        //增加btn
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i *(img.size.width + 10)+7.5, 2, img.size.width, img.size.height)];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        //检查名字
        NSString* name = @"";
        AddAudioAction* audioAction = (AddAudioAction*)act;
        if ([audioAction.audioFilePath hasSuffix:@"dub1.mp4"]) {
            name = @"音乐1";
        } else if ([audioAction.audioFilePath hasSuffix:@"dub2.mp4"]) {
            name = @"音乐2";
        } else if ([audioAction.audioFilePath hasSuffix:@"dub3.mp4"]) {
            name = @"音乐3";
        }
        [btn setTitle:name forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCallBack:)];
        [btn addGestureRecognizer:longPress];
        [arrayDraw addObject:btn];
    }
    
    [_actionCacheView setViewArray:arrayDraw];
    [_actionCacheView refreshScrollView];
    [_actionCacheView scrollRectToVisible:CGRectMake(_actionCacheView.contentSize.width - _actionCacheView.frame.size.width, 0, _actionCacheView.frame.size.width, _actionCacheView.frame.size.height) animated:YES];
    _actionCacheView.selectedIndex = _actionCacheView.viewArray.count - 1;

}

- (void)longPressCallBack:(UILongPressGestureRecognizer*)sender
{
    if ([sender state]==UIGestureRecognizerStateBegan)
    {
        //长按删除
        int index = sender.view.tag;
        if (_editType == EditTypeMagic) {
            _playerView.mediaEditor->RemoveVideoAction(index);
            [self showVideoActionList];
        } else {
            _playerView.mediaEditor->RemoveAudioAction(index);
            [self showAudioActionList];
        }
        
    }
}

- (void)addFilterAction:(int)tag
{
    switch (tag) {
        case 1:
        {
            //黑白
            MonochromeFilterAction *act = [[MonochromeFilterAction alloc] init];
            act.beginTime = _magicTimeline.videoStartTime;
            act.endTime = _magicTimeline.videoEndTime;
            
            [_playerView monochromeFilter:act];
        }
            break;
        case 2:
        {
            //反色
            NegativeFilterAction *act = [[NegativeFilterAction alloc] init];
            act.beginTime = _magicTimeline.videoStartTime;
            act.endTime = _magicTimeline.videoEndTime;
            
            [_playerView negativeFilter:act];
        }
            break;
        default:
            break;
    }
}

- (void)addAudioActionWithTag:(int)tag
{
    NSString* path = @"";
    switch (tag) {
        case 0:
        {
            path = [[NSBundle mainBundle] pathForResource:@"dub1" ofType:@"mp4"];
        }
            break;
        case 1:
        {
            path = [[NSBundle mainBundle] pathForResource:@"dub2" ofType:@"mp4"];
        }
            break;
        case 2:
        {
            path = [[NSBundle mainBundle] pathForResource:@"dub3" ofType:@"mp4"];
        }
            break;
        default:
            break;
    }
        
        AddAudioAction* act = [[AddAudioAction alloc] init];
        act.beginTime = _cutTimeline.videoStartTime;
        act.endTime = _cutTimeline.videoEndTime;
        act.audioBeginTime = 0;
        act.audioEndTime = 0;
        act.audioFilePath = path;
        act.volumeRate = _musicSlider.sliderValue;
        
        [_playerView addAudio:act];
        [self showAudioActionList];
}

@end
