//
//  ThunbImgWithBuffer.m
//  VideoEditer
//
//  Created by leipeilin on 13-8-6.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "ThunbImgWithBuffer.h"

@implementation ThunbImgWithBuffer

- (void)dealloc
{
    if (self.buffer != NULL) {
        delete self.buffer;
    }
}

@end
