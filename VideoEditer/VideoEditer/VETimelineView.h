//
//  VETimelineView.h
//  VideoEditer
//
//  Created by liulu on 13-8-22.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mediaeditor.h"
#import "VETimelinePicView.h"

#define def_ThumbViewWidth 272
#define def_FrameEdgeInset 12

typedef enum {
    timelineTouchTypeNULL = 0,
    timelineTouchTypeBeginTime,
    timelineTouchTypeEndTime,
    timelineTouchTypeMid
}timelineTouchType;

@protocol VETimeLineViewDelegate;

@interface VETimelineView : UIView
{
    UIImageView* _imgvFrame;
    
    VETimelinePicView* _picView;
    
    NSTimer* _timerLoadTime;
    timelineTouchType _touchType;
    
    UIView* _maskViewBegin;
    UIView* _maskViewEnd;
    
    CGFloat _touchMidToBeginValue;
    CGFloat _touchMidToEndValue;
}

@property (assign, nonatomic) CGFloat videoWidth;
@property (assign, nonatomic) CGFloat videoHeight;
@property (assign, nonatomic) CGFloat videoLength;

@property (assign, nonatomic) CGFloat beginOrigin;
@property (assign, nonatomic) CGFloat endOrigin;

@property (assign, nonatomic, readonly) CGFloat videoStartTime;
@property (assign, nonatomic, readonly) CGFloat videoEndTime;

@property (assign, nonatomic) CGFloat progressTime;

@property (assign, nonatomic) id<VETimeLineViewDelegate> delegate;

@property (assign, nonatomic) MediaEditor* mediaEidtor;

- (void)loadTimelineImgList;

- (void)reloadViewWithStartTime:(int64_t)startTime andEndTime:(int64_t)endTime;

@end

@protocol VETimeLineViewDelegate <NSObject>

- (void)resetBeginTime:(int64_t)beginTime andEndTime:(int64_t)endTime;

@end
