//
//  PageScrollView.m
//  VideoEditer
//
//  Created by Clark on 13-8-22.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "PageScrollView.h"
#import <QuartzCore/QuartzCore.h>

#define  PIC_WIDTH 34
#define  PIC_HEIGHT 34
#define  INSETS 5

@implementation PageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)refreshScrollView
{
    CGFloat width = (10 + (PIC_WIDTH + 10) * (_viewArray.count) < self.frame.size.width) ? self.frame.size.width: 10 + (PIC_WIDTH + 10) * (_viewArray.count);
    CGSize contentSize = CGSizeMake(width, self.frame.size.height);
    [self setContentSize:contentSize];
    [self setContentOffset:CGPointMake(width < 320 ? 0 : width-320 ,0) animated:YES];
}

- (void)setSelectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
    for (UIView* view in [self subviews]) {
        if (view.tag == selectedIndex&&view!=_selectedImgview) {
            [UIView animateWithDuration:0.3 animations:^{
                _selectedImgview.frame = CGRectMake(view.frame.origin.x-1.5, view.frame.origin.y-1.5, _selectedImgview.frame.size.width, _selectedImgview.frame.size.height);
            }];
        }
    }
}

- (void)setViewArray:(NSMutableArray *)viewArray
{
    _viewArray = viewArray;
    for (UIView* view in [self subviews]) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < viewArray.count; i ++) {
        UIButton *btnView = [viewArray objectAtIndex:i];
        [self addSubview:btnView];
        if (!_selectedImgview) {
            _selectedImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"action_frame_selected"]];
        }
        [self addSubview:_selectedImgview];
        _selectedImgview.hidden = NO;
        [self bringSubviewToFront:_selectedImgview];
        self.selectedIndex = 0;
    }
}

- (void)refreshSubView
{
    for (UIView* view in [self subviews]) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < _viewArray.count; i ++) {
        UIButton *btnView = [_viewArray objectAtIndex:i];
        [self addSubview:btnView];
        if (!_selectedImgview) {
            _selectedImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"action_frame_selected"]];
        }
        [self addSubview:_selectedImgview];
        _selectedImgview.hidden = NO;
        [self bringSubviewToFront:_selectedImgview];
    }
}

@end
