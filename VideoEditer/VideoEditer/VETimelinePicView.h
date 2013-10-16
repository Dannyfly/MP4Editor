//
//  VETimelinePicView.h
//  VideoEditer
//
//  Created by liulu on 13-8-22.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mediaeditor.h"

@interface VETimelinePicView : UIView

{
    NSMutableArray* _arrayTimelineImg;
}

@property (assign, nonatomic) CGFloat videoWidth;
@property (assign, nonatomic) CGFloat videoHeight;
@property (assign, nonatomic) CGFloat videoLength;

@property (assign, nonatomic) MediaEditor* mediaEidtor;

- (void)loadTimelineImgList;

@end
