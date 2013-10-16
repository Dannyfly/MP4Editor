//
//  VEVideoPlayingView.h
//  VideoEditer
//
//  Created by leipeilin on 13-8-7.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "opengl_view.h"
#include "mediaeditor.h"
#include "base_opengl_view.h"

#define TMP_TMP_DIR [[NSString stringWithFormat:@"%@/VideoCache",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]] UTF8String]
#define SAVE_FILE [NSString stringWithFormat:@"%@/VideoCache/save.mp4",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]


@protocol VEVideoPlayingViewDelegate;

@interface VEVideoPlayingView : UIView<MediaEditorCallback>
{
    OpenGLView* _openglView;        // OpenGL 视频渲染类
    
    uint8_t*    _thumBuf;           // 存储当前(_curTime)缩略图
    int         _thumBufLen;        
    
}

@property (assign, nonatomic) id<VEVideoPlayingViewDelegate> delegate;

@property (retain, nonatomic) OpenGLView* openglView;

@property (strong, nonatomic) NSString* filePath;           // 源文件路径
@property (strong, nonatomic) NSString* saveFilePath;       // 目标文件(保存)路径

@property (assign, nonatomic) int64_t beginTime;
@property (assign, nonatomic) int64_t endTime;
@property (assign, nonatomic) int64_t curTime;

//@property (assign, nonatomic) CGFloat* playingTimeValue;

@property (assign, nonatomic) MediaEditor *mediaEditor;     // 媒体操作类
@property (assign, nonatomic) MediaFormat mediaFormat;      // 媒体描述信息类

- (void)startPlay;
- (void)stopPlay;
- (void)pausePlay;
- (void)resumePlay;

//EditAction
- (void)cutVideo;
- (void)addAudio:(AddAudioAction*)act;
- (void)monochromeFilter:(MonochromeFilterAction*)act;
- (void)negativeFilter:(NegativeFilterAction*)act;
- (void)addWatermark:(WatermarkFilterAction*)act;
- (BOOL)saveFileToPath:(NSString*)saveFilePath;

@end

@protocol VEVideoPlayingViewDelegate <NSObject>

-(void)videoPlayingViewStartPlay;
-(void)videoPlayingViewStopPlay;
-(void)videoPlayingViewPausePlay;
-(void)videoPlayingViewResumePlay;

-(void)videoPlayingTime:(int64_t)time;
-(void)videoSavingPercentage:(int)value :(int)type;

@end
