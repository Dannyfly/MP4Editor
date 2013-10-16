//
//  VETimelinePicView.m
//  VideoEditer
//
//  Created by liulu on 13-8-22.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "VETimelinePicView.h"
#import "SerializationAction.h"
#import "ThunbImgWithBuffer.h"

#define def_ThumbViewWidth 272

@implementation VETimelinePicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _arrayTimelineImg = [[NSMutableArray alloc] init];
        
        _videoWidth = 0;
        _videoHeight = 0;
        _videoLength = 0;
        
        
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)loadTimelineImgList
{
    //时间轴内框宽555，高58，根据视频尺寸来确定缩略图数量,两倍图除2
    //时间轴内框左边到外框距离为23,上边到外框距离为8
    [_arrayTimelineImg removeAllObjects];
    
    //计算缩略图数量
    int imgNum = self.frame.size.width/(self.frame.size.height*_videoWidth/_videoHeight);
    int64_t cutTime = _videoLength/imgNum;
    for (int i = 0; i < imgNum; i++) {
        //这里获取缩略图，添加到数组
        ThunbImgWithBuffer* imgWithBuffer = [[ThunbImgWithBuffer alloc] init];
        self.mediaEidtor->GetThumbnailImage(cutTime*i, imgWithBuffer);
        [_arrayTimelineImg addObject:imgWithBuffer];
    }
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //画缩略图
    //时间轴内框左边到外框距离为23,上边到外框距离为8
    CGFloat width = self.frame.size.height*_videoWidth/_videoHeight;
    for (int i = 0; i<[_arrayTimelineImg count]; i++) {
        ThunbImgWithBuffer* timelineImg = [_arrayTimelineImg objectAtIndex:i];
        [timelineImg.image drawInRect:CGRectMake(width*i, 0 , width, self.frame.size.height)];
    }
}

@end
