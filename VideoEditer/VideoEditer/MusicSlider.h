//
//  MusicSlider.h
//  VideoEditer
//
//  Created by liulu on 13-9-4.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicSliderDelegate; 

@interface MusicSlider : UIView
{
    UIImage* _backgroundImage;
    UIImage* _progressImage;
    UIImage* _progressIcon;
}

@property (assign, nonatomic) CGFloat sliderValue;
@property (assign, nonatomic) id<MusicSliderDelegate> delegate;

@end

@protocol MusicSliderDelegate <NSObject>

- (void)musicSliderValueDidChanged:(CGFloat)sliderValue;

@end
