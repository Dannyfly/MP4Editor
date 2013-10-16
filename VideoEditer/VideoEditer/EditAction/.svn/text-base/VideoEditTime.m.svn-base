//
//  VideoEditTime.m
//  VideoEditer
//
//  Created by liulu on 13-8-2.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "VideoEditTime.h"

@implementation VideoEditTime

- (id)init
{
    self = [super init];
    if (self) {
        _hh = 0;
        _mm = 0;
        _ss = 0;
    }
    return self;
}

- (void)setHh:(int)hh
{
    if (hh<0) {
        _hh = 0;
    } else {
        _hh = hh;
    }
}

- (void)setMm:(int)mm
{
    if (mm<0) {
        _mm = 0;
    } else {
        _mm = mm;
    }
}

- (void)setSs:(float)ss
{
    if (ss<0) {
        _ss = 0;
    } else {
        _ss = ss;
    }
}

- (float)timeFloatValue
{
    return _hh*60*60+_mm*60+_ss;
}

@end
