//
//  VideoEditController.h
//  VideoEditer
//
//  Created by Clark on 13-8-22.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEVideoPlayingView.h"
#import "VETimelineView.h"
#import "SerializationAction.h"
#import "PageScrollView.h"
#import "ProgressBar.h"
#import "MyView.h"
#import "MusicSlider.h"
#import "UIView+Animation.h"

typedef enum {
    MagicTypeWatermark = 0,
    MagicTypeFilter
} MagicType;

typedef enum {
    EditTypeMagic = 0,
    EditTypeMusic
} EditType;

@interface VideoEditController : UIViewController<VEVideoPlayingViewDelegate,VETimeLineViewDelegate,MusicSliderDelegate,ProgressBarDelegate>
{
    CGRect _oldBounds;
    
    EditType _editType;
    
    //播放
    UIImageView *_playVideoView;
    ProgressBar* _playVideoProgressBar;
    
    VEVideoPlayingView* _playerView;
    MyView* _drawView;
    
    //编辑动作缓存
    PageScrollView* _actionCacheView;
    
    //切换按钮
    UIButton *_btnMagic;
    UIButton *_btnMusic;
    UIButton *_btnCut;
    
    //效果
    UIImageView* _imgSelectEditType;
    UIView *_magicView;
    VETimelineView* _magicTimeline;
    PageScrollView* _magicPageView;
    PageScrollView* _magicDrawPageView;
    NSArray* _filterList;
    
    //音乐
    UIView *_musicView;
    PageScrollView *_musicPageView;
    MusicSlider* _musicSlider;
    
    //裁剪
    UIView *_cutView;
    VETimelineView* _cutTimeline;
    
    //保存输出文件
    UIView* _saveMaskView;
    UIProgressView* _saveProgressview;

}

@property (nonatomic, strong) NSString* videoPath;

@end
