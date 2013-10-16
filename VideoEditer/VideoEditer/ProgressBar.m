//
//  ProgressBar.m
//  VideoEditer
//
//  Created by liulu on 13-7-30.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "ProgressBar.h"

@implementation ProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (systemVersion >= 5.0) {
//            self.backgroundImage = [[UIImage imageNamed:@"progressbar_backgroundimage.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
//            self.progressImage = [[UIImage imageNamed:@"progressbar_image.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 5, 3, 5)];
            _progressImage = [[UIImage imageNamed:@"progressbar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 2, 1, 2)];
            
        } else {
//            self.backgroundImage = [[UIImage imageNamed:@"progressbar_backgroundimage.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
//            self.backgroundImage = [[UIImage imageNamed:@"progressbar_image.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:3];
            _progressImage = [[UIImage imageNamed:@"progressbar_bg"] stretchableImageWithLeftCapWidth:2 topCapHeight:1];
        }
        _progressIcon = [UIImage imageNamed:@"progressbar_icon"];
        
        self.backgroundColor = [UIColor clearColor];
        
        _progress = 0.0f;
        _beginValue = 0.0f;
        _endValue = 1.0f;
    }
    return self;
}

- (void) setProgress:(CGFloat)progress
{
    _progress = progress;
    if (self.progress < self.beginValue) {
        _progress = self.beginValue;
    }
    if (self.progress > self.endValue) {
        _progress = self.endValue;
    }
    [self setNeedsDisplay];
}

- (void)setBeginValue:(CGFloat)beginValue
{
    if (beginValue<0) {
        beginValue = 0;
    }
    _beginValue = beginValue;
    if (self.progress < self.beginValue) {
        self.progress = self.beginValue;
    }
    [self setNeedsDisplay];
}

- (void)setEndValue:(CGFloat)endValue
{
    if (endValue>1) {
        endValue = 1;
    }
    if (self.progress > self.endValue) {
        self.progress = self.endValue;
    }
    _endValue = endValue;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_progressImage drawInRect:CGRectMake(self.frame.size.width*self.beginValue, 5.5, self.frame.size.width * self.endValue-self.frame.size.width*self.beginValue, 3)];
    CGFloat progressIconX = (self.frame.size.width * self.progress)-6.5;
    if (progressIconX<0) {
        progressIconX = 0;
    } else if (progressIconX>self.frame.size.width-13) {
        progressIconX = self.frame.size.width-13;
    }
    [_progressIcon drawInRect:CGRectMake(progressIconX, 1, 13, 14)];
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
    self.progress = progress/self.frame.size.width;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressChanged:)]) {
        [self.delegate progressChanged:_progress];
    }
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
    self.progress = progress/self.frame.size.width;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressChanged:)]) {
        [self.delegate progressChanged:_progress];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
    CGFloat progress = pt.x;
    if (pt.x<0) {
        progress = 0;
    } else if (pt.x > self.frame.size.width) {
        progress = self.frame.size.width;
    }
    self.progress = progress/self.frame.size.width;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressChanged:)]) {
        [self.delegate progressChanged:_progress];
    }
}

@end
