//
//  MusicSlider.m
//  VideoEditer
//
//  Created by liulu on 13-9-4.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "MusicSlider.h"

@implementation MusicSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (systemVersion >= 5.0) {
            _backgroundImage = [[UIImage imageNamed:@"add_bgmusic_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 4, 2, 4)];
        } else {
            _backgroundImage = [[UIImage imageNamed:@"add_bgmusic_bg"] stretchableImageWithLeftCapWidth:4 topCapHeight:2];
        }
        _progressIcon = [UIImage imageNamed:@"add_bgmusic_icon"];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSliderValue:(CGFloat)sliderValue
{
    _sliderValue = sliderValue;
    [self setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(musicSliderValueDidChanged:)]) {
        [self.delegate musicSliderValueDidChanged:_sliderValue];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_backgroundImage drawInRect:CGRectMake(0, 8.5, self.frame.size.width, 6)];
    CGFloat progressIconX = (self.frame.size.width * self.sliderValue)-11.5;
    if (progressIconX<0) {
        progressIconX = 0;
    } else if (progressIconX>self.frame.size.width-23) {
        progressIconX = self.frame.size.width-23;
    }
    [_progressIcon drawInRect:CGRectMake(progressIconX, 0, 23, 23)];

    CGContextSaveGState(context);
}

#pragma mark -
#pragma mark touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
    CGFloat progress = pt.x;
    if (pt.x<0) {
        progress = 0;
    } else if (pt.x > self.frame.size.width) {
        progress = self.frame.size.width;
    }
    self.sliderValue = progress/self.frame.size.width;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
    CGFloat progress = pt.x;
    if (pt.x<0) {
        progress = 0;
    } else if (pt.x > self.frame.size.width) {
        progress = self.frame.size.width;
    }
    self.sliderValue = progress/self.frame.size.width;
}

@end
