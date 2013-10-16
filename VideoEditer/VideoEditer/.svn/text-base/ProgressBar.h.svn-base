//
//  ProgressBar.h
//  VideoEditer
//
//  Created by liulu on 13-7-30.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressBarDelegate;

@interface ProgressBar : UIView
{
    UIImage* _backgroundImage;
    UIImage* _progressImage;
    UIImage* _progressIcon;
}

@property (assign, nonatomic) CGFloat beginValue;
@property (assign, nonatomic) CGFloat endValue;
@property (assign, nonatomic) CGFloat progress;

@property (assign, nonatomic) id<ProgressBarDelegate> delegate;

@end

@protocol ProgressBarDelegate <NSObject>

- (void)progressChanged:(CGFloat)progressValue;

@end