//
//  VEVideoPlayingView.m
//  VideoEditer
//
//  Created by leipeilin on 13-8-7.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "VEVideoPlayingView.h"
#include "ios_opengl_view.h"

#define DEF_PLAYBTN_TAG 8121348

@implementation VEVideoPlayingView
@synthesize openglView = _openglView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _filePath = @"";
        _saveFilePath = @"";
        _beginTime = 0;
        _endTime = 0;
        _curTime = 0;
        
        // 添加 OpenGL View
        /****************** OpenGLES ******************/
        _openglView = [[OpenGLView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        [_openglView setBackgroundColor:[UIColor redColor]];
        [self setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_openglView];      // 添加 openglView
        [_openglView setOpenglViewMode: OPENGLVIEW_DISPLAY: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        /****************** OpenGLES ******************/
        
        
        //播放按钮begin
        UIButton* btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50, self.frame.size.height-50, 40, 40)];
        [btnPlay setImage:[UIImage imageNamed:@"play_normal.png"] forState:UIControlStateNormal];
        [btnPlay setImage:[UIImage imageNamed:@"play_highlight.png"] forState:UIControlStateHighlighted];
        [btnPlay addTarget:self action:@selector(btnPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnPlay];
        btnPlay.tag = DEF_PLAYBTN_TAG;
        //播放按钮end
        
        // 1、实例化MediaEditor对象
        _mediaEditor = new MediaEditor;
    }
    return self;
}

- (void)dealloc
{
    if(_thumBuf)
    {
        delete _thumBuf;
        _thumBuf = NULL;
    }
    
    // 销毁对象，释放内存
    if (_mediaEditor)
    {
        delete _mediaEditor;
        _mediaEditor = NULL;
    }
}

#pragma mark -
#pragma mark setter
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _openglView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

static FILE *tmp = NULL;
static bool isCreate = false;


- (void)setFilePath:(NSString *)filePath
{
    int ret;
    _filePath = filePath;
    
    ret = _mediaEditor->Open( [self.filePath UTF8String], (__bridge void *)self);
    if (ret != 0)
        return;
    _mediaEditor->SetTempDir(TMP_TMP_DIR);
    _mediaEditor->GetFormat(_mediaFormat);
    
    _beginTime = 0;
    _endTime = _mediaFormat._totaltime;
    _curTime = 0;
    _mediaEditor->SetPeriod(_beginTime, _mediaFormat._totaltime);
    
    
    _thumBufLen = _mediaFormat._width * _mediaFormat._height * 3 / 2;
    _thumBuf = new uint8_t[_thumBufLen];
    _mediaEditor->GetThumbnail((char *)_thumBuf, _thumBufLen, _beginTime, _mediaFormat._width, _mediaFormat._height);
    [_openglView render :0 :_thumBuf :_mediaFormat._width: _mediaFormat._height];
    
    _mediaEditor->StartPlayer();
    _mediaEditor->PausePlayer();
}

- (void)setBeginTime:(int64_t)beginTime
{
    _beginTime = beginTime;
    _mediaEditor->SetPeriod(self.beginTime, self.endTime);
}

- (void)setEndTime:(int64_t)endTime
{
    _endTime = endTime;
    _mediaEditor->SetPeriod(self.beginTime, self.endTime);
}

- (void)setCurTime:(int64_t)curTime
{
    _curTime = curTime;
    _mediaEditor->SetCurTime(curTime);
}

#pragma mark -
#pragma mark playAction

- (void)btnPlayClicked:(UIButton*)sender
{
    FFPLAY_STATE state = _mediaEditor->GetPlayState();
    switch (state) {
        case FFPLAY_STATE_CLOSED:
        case FFPLAY_STATE_STOPED:
            [self startPlay];
            break;
        case FFPLAY_STATE_PLAYING:
            [self pausePlay];
            break;
        case FFPLAY_STATE_PAUSED:
            [self resumePlay];
            break;
        default:
            break;
    }
}

- (void)startPlay
{
    @autoreleasepool {
        [_openglView setOpenglViewMode: OPENGLVIEW_DISPLAY: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mediaEditor->StartPlayer();
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayingViewStartPlay)]) {
            [self.delegate videoPlayingViewStartPlay];
        }
    }
}

- (void)stopPlay
{
    @autoreleasepool {
        _mediaEditor->ClosePlayer();
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayingViewStopPlay)]) {
            [self.delegate videoPlayingViewStopPlay];
        }
    }
}

- (void)pausePlay
{
    @autoreleasepool {
        _mediaEditor->PausePlayer();
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayingViewPausePlay)]) {
            [self.delegate videoPlayingViewPausePlay];
        }
    }
}

- (void)resumePlay
{
    @autoreleasepool {
        _mediaEditor->ResumePlayer();
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayingViewResumePlay)]) {
            [self.delegate videoPlayingViewResumePlay];
        }
    }
}

#pragma mark -
#pragma mark editAction

- (void)cutVideo
{
    // 如果没有拖动过选区区域，则不裁剪
    if (_beginTime == 0 && _endTime == _mediaFormat._totaltime)
    {
        printf("Info: prease drop the time control bufore cut media file ! \n");
        return;
    }
    
    string cutDestPath = "";
    cutDestPath = cutDestPath + TMP_TMP_DIR + "/cutting.mp4";
    _mediaEditor->Cut(cutDestPath.c_str());
    
}

// 混音(暂时)
- (void)addAudio:(AddAudioAction*)act
{
    
    Json::Value action;
    
    action["Name"] = [act.actionName UTF8String];
    action["BeginTime"] = act.beginTime;
    action["EndTime"] = act.endTime;
    action["FilePath"] = [act.audioFilePath UTF8String];
    action["AudioBeginTime"] = act.audioBeginTime;
    action["AudioEndTime"] = act.audioEndTime;
    action["VolumeRate"] = act.volumeRate;
    
    _mediaEditor->AddAudioAction(action);
}

// 单色滤镜
- (void)monochromeFilter:(MonochromeFilterAction*)act
{
    Json::Value action;
    action["Name"] = [act.actionName UTF8String];
    action["BeginTime"] = act.beginTime;
    action["EndTime"] = act.endTime;
    
    // 渲染当前帧
    _mediaEditor->GetThumbnail((char *)_thumBuf, _thumBufLen, _curTime, _mediaFormat._width, _mediaFormat._height);
    [_openglView render :1 :_thumBuf :_mediaFormat._width: _mediaFormat._height];
    _mediaEditor->AddVideoAction(action);
    
}

//反色
- (void)negativeFilter:(NegativeFilterAction*)act
{
    Json::Value action;
    action["Name"] = [act.actionName UTF8String];
    action["BeginTime"] = act.beginTime;
    action["EndTime"] = act.endTime;
    
    // 渲染当前帧
    _mediaEditor->GetThumbnail((char *)_thumBuf, _thumBufLen, _curTime, _mediaFormat._width, _mediaFormat._height);
    [_openglView render :2 :_thumBuf :_mediaFormat._width: _mediaFormat._height];
    
    _mediaEditor->AddVideoAction(action);
}

- (void)addWatermark:(WatermarkFilterAction*)act
{
    Json::Value action;
    action["Name"] = [act.actionName UTF8String];
    action["BeginTime"] = act.beginTime;
    action["EndTime"] = act.endTime;
    action["ImgPath"] = [act.imgPath UTF8String];
    action["Width"] = act.width;
    action["Height"] = act.height;
    
    _mediaEditor->_vidfilter.Stop();
    _mediaEditor->AddVideoAction(action);
}

- (BOOL)saveFileToPath:(NSString*)saveFilePath
{
    [_openglView setOpenglViewMode: OPENGLVIEW_TRANSFER: CGRectMake(0, 0, 568, 320)];
    
    //保存成功返回yes
    saveFilePath = SAVE_FILE;
    const char* destDir = [saveFilePath UTF8String];
    _mediaEditor->Save2File(destDir);
    return YES;
}

#pragma mark -
#pragma mark MediaEditorCallback
- (void)PreviewTimeCallback:(int64_t)curTime
{
    @autoreleasepool {
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayingTime:)]) {
            [self.delegate videoPlayingTime:curTime];
        }

    }
}

-(void)SaveProgressCallback:(int)percentage:(int)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoSavingPercentage::)]) {
        [self.delegate videoSavingPercentage:percentage:type];
    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
