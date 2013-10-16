//
//  VETimelineView.m
//  VideoEditer
//
//  Created by liulu on 13-8-22.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "VETimelineView.h"
#import "SerializationAction.h"
#import "ThunbImgWithBuffer.h"

@implementation VETimelineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _videoLength = self.frame.size.width;
        _videoStartTime = 0;
        _videoEndTime = self.frame.size.width;
        
        _beginOrigin = 0;
        _endOrigin = 0;
        
        _videoStartTime = 0;
        _videoEndTime = 0;
        
        //背景缩略图
        _picView = [[VETimelinePicView alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.width-10, self.frame.size.height-4)];
        [self addSubview:_picView];
        
        _maskViewBegin = [[UIView alloc] initWithFrame:CGRectMake(5, 2, 0, self.frame.size.height-4)];
        _maskViewBegin.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _maskViewEnd = [[UIView alloc] initWithFrame:CGRectMake(5, 2, 0, self.frame.size.height-4)];
        _maskViewEnd.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:_maskViewBegin];
        [self addSubview:_maskViewEnd];
        
        //外框
        UIEdgeInsets capInsets = UIEdgeInsetsMake(10, 18, 10, 18);
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        UIImage* image = [UIImage imageNamed:@"timeline_frame"];
        if (systemVersion >= 5.0) {
            image = [image resizableImageWithCapInsets:capInsets];
        } else {
            image = [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
        }
        _imgvFrame = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imgvFrame.image = image;
        [self addSubview:_imgvFrame];
    }
    return self;
}

#pragma mark -
#pragma mark Setter
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imgvFrame.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _maskViewBegin.frame = CGRectMake(5, 2, 0, self.frame.size.height-4);
    _maskViewEnd.frame = CGRectMake(5, 2, 0, self.frame.size.height-4);
    _picView.frame = CGRectMake(5, 2, self.frame.size.width-10, self.frame.size.height-4);
}

- (void)setVideoWidth:(CGFloat)videoWidth
{
    _videoWidth = videoWidth;
    _picView.videoWidth = _videoWidth;
}

- (void)setVideoHeight:(CGFloat)videoHeight
{
    _videoHeight = videoHeight;
    _picView.videoHeight = _videoHeight;
}

- (void)setVideoLength:(CGFloat)videoLenth
{
    _videoLength = videoLenth;
    _picView.videoLength = _videoLength;
    _videoEndTime = _videoLength;
}

- (void)setMediaEidtor:(MediaEditor *)mediaEidtor
{
    _mediaEidtor = mediaEidtor;
    _picView.mediaEidtor = _mediaEidtor;
}

- (void)setBeginOrigin:(CGFloat)beginOrigin
{
    _beginOrigin = beginOrigin;
    if (_beginOrigin != _endOrigin) {
        //限制可编辑区域
        if (_videoStartTime<self.beginOrigin) {
            _videoStartTime = self.beginOrigin;
        }
        //左右不超过边框
        if (_videoStartTime < def_FrameEdgeInset/2) {
            _videoStartTime = def_FrameEdgeInset/2;
        } else if (_videoStartTime > self.frame.size.width-def_FrameEdgeInset/2) {
            _videoStartTime = self.frame.size.width-def_FrameEdgeInset/2;
        }
        //结束时间同样需要约束间隔
        if (_videoEndTime>self.frame.size.width-def_FrameEdgeInset/2) {
            _videoEndTime = self.frame.size.width-def_FrameEdgeInset/2;
        }
        //不超过起始时间并预留一定距离
        if (_videoEndTime < _videoStartTime+2*def_FrameEdgeInset) {
            _videoEndTime = _videoStartTime+2*def_FrameEdgeInset;
        }
        _imgvFrame.frame = CGRectMake(_videoStartTime-def_FrameEdgeInset/2, 0, (_endOrigin + def_FrameEdgeInset/2)-(_videoStartTime-def_FrameEdgeInset/2), self.frame.size.height);
        _maskViewBegin.frame = CGRectMake(5, 2, (_beginOrigin-def_FrameEdgeInset/2)-5+def_FrameEdgeInset/2, _maskViewBegin.frame.size.height);
        _maskViewEnd.frame = CGRectMake(((_beginOrigin-def_FrameEdgeInset/2)+(_endOrigin + def_FrameEdgeInset/2)-(_videoStartTime-def_FrameEdgeInset/2))-def_FrameEdgeInset/2, 2, self.frame.size.width-10-((_beginOrigin-def_FrameEdgeInset/2)+(_endOrigin + def_FrameEdgeInset/2)-(_videoStartTime-def_FrameEdgeInset/2))+def_FrameEdgeInset, _maskViewEnd.frame.size.height);
    }
}

- (void)setEndOrigin:(CGFloat)endOrigin
{
    _endOrigin = endOrigin;
    if (_endOrigin != _beginOrigin) {
        //限制可编辑区域
        if (_videoEndTime>self.endOrigin) {
            _videoEndTime = self.endOrigin;
        }
        //左右不超过边框
        if (_videoEndTime < def_FrameEdgeInset/2) {
            _videoEndTime = def_FrameEdgeInset/2;
        } else if (_videoEndTime > self.frame.size.width-def_FrameEdgeInset/2) {
            _videoEndTime = self.frame.size.width-def_FrameEdgeInset/2;
        }
        //起始时间同样需要约束间隔
        if (_videoStartTime<def_FrameEdgeInset/2) {
            _videoStartTime = def_FrameEdgeInset/2;
        }
        //不超过结束时间并预留一定距离
        if (_videoStartTime>_videoEndTime-2*def_FrameEdgeInset) {
            _videoStartTime = _videoEndTime-2*def_FrameEdgeInset;
        }
        _imgvFrame.frame = CGRectMake(_videoStartTime-def_FrameEdgeInset/2, 0, (_videoEndTime + def_FrameEdgeInset/2)-(_videoStartTime-def_FrameEdgeInset/2), self.frame.size.height);
        _maskViewBegin.frame = CGRectMake(5, 2, (_beginOrigin-def_FrameEdgeInset/2)-5+def_FrameEdgeInset/2, _maskViewBegin.frame.size.height);
        _maskViewEnd.frame = CGRectMake(((_beginOrigin-def_FrameEdgeInset/2)+(_endOrigin + def_FrameEdgeInset/2)-(_videoStartTime-def_FrameEdgeInset/2))-def_FrameEdgeInset/2, 2, self.frame.size.width-10-((_beginOrigin-def_FrameEdgeInset/2)+(_endOrigin + def_FrameEdgeInset/2)-(_videoStartTime-def_FrameEdgeInset/2))+def_FrameEdgeInset, _maskViewEnd.frame.size.height);
    }
}

#pragma mark -
#pragma mark Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchMidToBeginValue = 0;
    _touchMidToEndValue = 0;

    UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
    
    
    if (pt.x>=CGRectGetMinX(_imgvFrame.frame)-def_FrameEdgeInset*2&&pt.x<=CGRectGetMinX(_imgvFrame.frame)+def_FrameEdgeInset*2) {
        //点击在开始
        _touchType = timelineTouchTypeBeginTime;
    } else if (pt.x>=CGRectGetMaxX(_imgvFrame.frame)-def_FrameEdgeInset*2&&pt.x<=CGRectGetMaxX(_imgvFrame.frame)+def_FrameEdgeInset*2) {
        //点击在结束
        _touchType = timelineTouchTypeEndTime;
    } else if (pt.x > CGRectGetMinX(_imgvFrame.frame)+def_FrameEdgeInset*2&&pt.x<CGRectGetMaxX(_imgvFrame.frame)-def_FrameEdgeInset*2) {
        //点击在中间
        _touchType = timelineTouchTypeMid;
        _touchMidToBeginValue = pt.x - _videoStartTime;
        _touchMidToEndValue = _videoEndTime - pt.x;
    } else {
        _touchType = timelineTouchTypeNULL;
    }
    
    if (_touchType != timelineTouchTypeNULL) {
        _timerLoadTime = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(loadTime) userInfo:nil repeats:YES];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
    
    switch (_touchType) {
        case timelineTouchTypeBeginTime:
        {
            //点击在开始滑块上
            //左右不超过边框
            if (pt.x < def_FrameEdgeInset/2) {
                _videoStartTime = def_FrameEdgeInset/2;
            } else if (pt.x > self.frame.size.width-def_FrameEdgeInset/2) {
                _videoStartTime = self.frame.size.width-def_FrameEdgeInset/2;
            } else {
                _videoStartTime = pt.x;
            }
            if (_beginOrigin != _endOrigin && _videoStartTime<self.beginOrigin) {
                //限制可编辑区域
                _videoStartTime = self.beginOrigin;
            }
            //结束时间同样需要约束间隔
            if (_videoEndTime>self.frame.size.width-def_FrameEdgeInset/2) {
                _videoEndTime = self.frame.size.width-def_FrameEdgeInset/2;
            }
            //不超过结束时间并预留一定距离
            if (_videoStartTime>_videoEndTime-2*def_FrameEdgeInset) {
                _videoStartTime = _videoEndTime-2*def_FrameEdgeInset;
            }
            //点击开始滑块，播放进度滑块跟着动
            _progressTime = _videoStartTime;
            
        }
            break;
        case timelineTouchTypeEndTime:
        {
            //点击在结束滑块上
            //左右不超过边框
            if (pt.x < def_FrameEdgeInset/2) {
                _videoEndTime = def_FrameEdgeInset/2;
            } else if (pt.x > self.frame.size.width-def_FrameEdgeInset/2) {
                _videoEndTime = self.frame.size.width-def_FrameEdgeInset/2;
            } else {
                _videoEndTime = pt.x;
            }
            if (_endOrigin != _beginOrigin && _videoEndTime>self.endOrigin) {
                //限制可编辑区域
                _videoEndTime = self.endOrigin;
            }
            //起始时间同样需要约束间隔
            if (_videoStartTime<def_FrameEdgeInset/2) {
                _videoStartTime = def_FrameEdgeInset/2;
            }
            //不超过起始时间并预留一定距离
            if (_videoEndTime < _videoStartTime+2*def_FrameEdgeInset) {
                _videoEndTime = _videoStartTime+2*def_FrameEdgeInset;
            }
        }
            break;
        case timelineTouchTypeMid:
        {
            _videoStartTime = pt.x - _touchMidToBeginValue;
            _videoEndTime = pt.x + _touchMidToEndValue;
            //左右不超过边框
            if (_videoStartTime < def_FrameEdgeInset/2) {
                _videoStartTime = def_FrameEdgeInset/2;
            } else if (_videoStartTime > self.frame.size.width-def_FrameEdgeInset/2) {
                _videoStartTime = self.frame.size.width-def_FrameEdgeInset/2;
            }
            if (_beginOrigin != _endOrigin && _videoStartTime<self.beginOrigin) {
                //限制可编辑区域
                _videoStartTime = self.beginOrigin;
            }
            //结束时间同样需要约束间隔
            if (_videoEndTime>self.frame.size.width-def_FrameEdgeInset/2) {
                _videoEndTime = self.frame.size.width-def_FrameEdgeInset/2;
            }
            //不超过结束时间并预留一定距离
            if (_videoStartTime>_videoEndTime-2*def_FrameEdgeInset) {
                _videoStartTime = _videoEndTime-2*def_FrameEdgeInset;
            }
            //点击开始滑块，播放进度滑块跟着动
            _progressTime = _videoStartTime;
            
            
            //左右不超过边框
            if (_videoEndTime < def_FrameEdgeInset/2) {
                _videoEndTime = def_FrameEdgeInset/2;
            } else if (_videoEndTime > self.frame.size.width-def_FrameEdgeInset/2) {
                _videoEndTime = self.frame.size.width-def_FrameEdgeInset/2;
            }
            if (_endOrigin != _beginOrigin && _videoEndTime>self.endOrigin) {
                //限制可编辑区域
                _videoEndTime = self.endOrigin;
            }
            //起始时间同样需要约束间隔
            if (_videoStartTime<def_FrameEdgeInset/2) {
                _videoStartTime = def_FrameEdgeInset/2;
            }
            //不超过起始时间并预留一定距离
            if (_videoEndTime < _videoStartTime+2*def_FrameEdgeInset) {
                _videoEndTime = _videoStartTime+2*def_FrameEdgeInset;
            }
        }
        default:
            break;
    }
    
    _imgvFrame.frame = CGRectMake(_videoStartTime-def_FrameEdgeInset/2, 0, (_videoEndTime + def_FrameEdgeInset/2)-(_videoStartTime-def_FrameEdgeInset/2), self.frame.size.height);
//    _maskViewBegin.frame = CGRectMake(5, 2, _imgvFrame.frame.origin.x-5+def_FrameEdgeInset/2, _maskViewBegin.frame.size.height);
//    _maskViewEnd.frame = CGRectMake(CGRectGetMaxX(_imgvFrame.frame)-def_FrameEdgeInset/2, 2, self.frame.size.width-10-CGRectGetMaxX(_imgvFrame.frame)+def_FrameEdgeInset, _maskViewEnd.frame.size.height);

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchMidToBeginValue = 0;
    _touchMidToEndValue = 0;
    if (_touchType != timelineTouchTypeNULL) {
        [self loadTime];
    }
    if (_timerLoadTime) {
        [_timerLoadTime invalidate];
        _timerLoadTime = nil;
    }
}

- (void)loadTime
{
    //_videoStartTime实际是坐标，真实时间还需要计算
    int64_t stime = ((_videoStartTime-def_FrameEdgeInset/2)/def_ThumbViewWidth)*_videoLength;
    int64_t etime = ((_videoEndTime+def_FrameEdgeInset/2)/def_ThumbViewWidth)*_videoLength;
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetBeginTime:andEndTime:)]) {
        [self.delegate resetBeginTime:stime andEndTime:etime];
    }
}

- (void)loadTimelineImgList
{
    [_picView loadTimelineImgList];
}

- (void)reloadViewWithStartTime:(int64_t)startTime andEndTime:(int64_t)endTime
{
    _videoStartTime = (startTime/_videoLength)*self.frame.size.width;
    _videoEndTime = (endTime/_videoLength)*self.frame.size.width;
    
    //左右不超过边框
    if (_videoStartTime < def_FrameEdgeInset/2) {
        _videoStartTime = def_FrameEdgeInset/2;
    } else if (_videoStartTime > self.frame.size.width-def_FrameEdgeInset/2) {
        _videoStartTime = self.frame.size.width-def_FrameEdgeInset/2;
    }
    if (_beginOrigin != _endOrigin && _videoStartTime<self.beginOrigin) {
        //限制可编辑区域
        _videoStartTime = self.beginOrigin;
    }
    //结束时间同样需要约束间隔
    if (_videoEndTime>self.frame.size.width-def_FrameEdgeInset/2) {
        _videoEndTime = self.frame.size.width-def_FrameEdgeInset/2;
    }
    //不超过结束时间并预留一定距离
    if (_videoStartTime>_videoEndTime-2*def_FrameEdgeInset) {
        _videoStartTime = _videoEndTime-2*def_FrameEdgeInset;
    }
    //点击开始滑块，播放进度滑块跟着动
    _progressTime = _videoStartTime;
    
    //左右不超过边框
    if (_videoEndTime < def_FrameEdgeInset/2) {
        _videoEndTime = def_FrameEdgeInset/2;
    } else if (_videoEndTime > self.frame.size.width-def_FrameEdgeInset/2) {
        _videoEndTime = self.frame.size.width-def_FrameEdgeInset/2;
    }
    if (_endOrigin != _beginOrigin && _videoEndTime>self.endOrigin) {
        //限制可编辑区域
        _videoEndTime = self.endOrigin;
    }
    //起始时间同样需要约束间隔
    if (_videoStartTime<def_FrameEdgeInset/2) {
        _videoStartTime = def_FrameEdgeInset/2;
    }
    //不超过起始时间并预留一定距离
    if (_videoEndTime < _videoStartTime+2*def_FrameEdgeInset) {
        _videoEndTime = _videoStartTime+2*def_FrameEdgeInset;
    }
    _imgvFrame.frame = CGRectMake(_videoStartTime-def_FrameEdgeInset/2, 0, (_videoEndTime + def_FrameEdgeInset/2)-(_videoStartTime-def_FrameEdgeInset/2), self.frame.size.height);
}

@end
